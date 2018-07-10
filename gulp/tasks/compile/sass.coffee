{ basePath, src, dest, checkExistence } = G

bs = require 'browser-sync'
fsCSON = require 'fs-cson'

gulp.task 'compile:sass', (cb) ->
  checkExistence("#{src.styles}*.sass", 'sass', src.styles)

  options =
    autoprefixer:
      browsers: ['last 1 version', 'ie 10', '> 1%']
    cssGlobbing:
      extensions: ['.sass', '.scss']
    cssnano:
      discardComments: { removeAll: true }
    preprocess:
      context: { ENV: argv.env }
    sass:
      precision: 10
      includePaths: [
        './node_modules/resetcss'
        './node_modules/normalize.css'
        './node_modules/sass-mq'
        './node_modules/mathsass/dist'
      ]
    doiuse:
      browsers: [
        'ie >= 9'
      ]
      ignore: [
        'rem'
        'text-size-adjust'
        'font-smoothing'
        'outline'
      ]


  options.postcss = [
    require('autoprefixer')(options.autoprefixer)
  ]

  if process.env.doiuse == 'true'
    options.postcss.push(require('doiuse')(options.doiuse))

  if argv.archive
    options.assets =
      basePath: 'build/assets/'
      loadPaths: ['images/']
  else
    options.assets =
      basePath: 'build/'
      loadPaths: ['assets/images/']

  options.assets.loadPaths[0] += 'r/' if global.breakPointsConfig?
  options.postcss.push(require('postcss-assets')(options.assets))

  # gulp.src("#{src.styles}**/*.sass")
  #   .pipe $.sassLint()
  #   .pipe $.sassLint.format()

  gulp.src("#{src.styles}*.sass")
    .pipe $.if(!argv.minify, $.sourcemaps.init())
    .pipe $.cssGlobbing(options.cssGlobbing)
    .pipe $.if('all.sass', $.preprocess(options.preprocess))
    .pipe $.sass.sync(options.sass)
    .pipe $.postcss(options.postcss)
    .pipe $.if(!argv.minify, $.sourcemaps.write('.'))
    .pipe $.if(argv.minify, $.cssnano(options.cssnano))
    .pipe $.if(argv.relative, $.replace(/(url\(['|"]?)(\/)/g, "$1..$2"))
    .pipe gulp.dest(dest.styles)
    .pipe $.filter(['**/*.css'])
    .pipe bs.stream()
