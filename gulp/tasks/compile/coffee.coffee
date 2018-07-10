{ basePath, src, dest, checkExistence } = G

browserify = require 'browserify'
coffeeify  = require 'coffeeify'
aliasify   = require 'aliasify'
source     = require 'vinyl-source-stream'
buffer     = require 'vinyl-buffer'
glob       = require 'glob'
es         = require 'event-stream'

aliasifyConfig =
  aliases:
    data: './data'

gulp.task 'compile:coffee', (cb) ->
  pat = "#{src.scripts}!(_*).coffee"
  checkExistence(pat, 'coffee', src.scripts)

  glob pat, (err, files) ->
    return cb() if !files.length

    tasks = files.map (entry) ->
      browserify(
          entries: [entry]
          extensions: ['.coffee']
          debug: true
        )
        .transform(coffeeify)
        .transform(aliasify, aliasifyConfig)
        .bundle()
        .on 'error', G.onError
        .pipe source(entry)
        .pipe $.rename {
            dirname: ''
            extname: '.js'
          }
        .pipe buffer()
        .pipe $.if(argv.minify, $.uglify())
        .pipe gulp.dest(dest.scripts)

    es.merge(tasks).on 'end', cb
