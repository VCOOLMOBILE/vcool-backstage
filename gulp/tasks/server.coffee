{ basePath, src } = G
bs = require 'browser-sync'
rs = require 'run-sequence'
reload = bs.reload

kexec = require 'kexec'

gulp.task 'gulp-reload', ->
  logger.info('gulpfile changed')
  command = [argv._.join(' ') || 'default']
  for arg, setting of argv
    command.push("--#{arg}", setting) if !(arg in ['$0', '_'])
  command.push('--restart', 'true') if !argv.restart

  kexec('gulp', command)

gulp.task 'dev-server', (cb) ->
  bsOptions =
    server:
      baseDir: basePath.dest
      index: 'index.html'
    port: process.env.dev_port || 9000
    open: process.env.open_browser || 'true'
    reloadOnRestart: true
    extensions: 'html'

  bsOptions.open = false if argv.restart

  bs bsOptions

  eventPairs = [
    ["#{basePath.src}**/*.pug", "#{basePath.data}**/*"],        ['compile:pug', reload]
    "#{src.styles}**/*.{sass,scss}",                            ['compile:sass']
    "#{src.scripts}**/*",                                       ['compile:coffee', reload]
    "#{basePath.config}shared.yml",                             ['compile', reload]
    "#{basePath.libs}images/svg-sprites/*.handlebars",          ['images:svg-sprites']
    "#{src.sketch}*.sketch",                                    ['images:sketch', 'images:resize', 'images:svg-sprites', reload]
    "#{basePath.config}image-breakpoints.cson",                 ['images:resize', reload]
    "#{src.images}**/*",                                        ['images', reload]
  ]

  eventPairs.push(['./gulpfile.coffee', './gulp/**/*.coffee'], ['gulp-reload']) if process.env.restart_on_gulpfile_change
  eventPairs.forEach (files, i, arr) ->
    $.watch(files, -> rs.apply(null, arr[i+1])) if i % 2 == 0

  cb()
