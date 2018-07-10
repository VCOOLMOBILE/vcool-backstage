{ basePath, src, dest, checkExistence } = G
which = require('npm-which')(__dirname)
glob = require 'glob'
es = require 'event-stream'
imagemin = require "#{basePath.libs}images/imagemin"

gulp.task 'images:sketch', (cb) ->
  # to skip this task for windows user
  try
    which.sync('sketchtool')
  catch err
    return logger.warn(err)

  checkExistence "#{src.sketch}*.sketch", 'sketch', src.sketch

  glob "#{src.sketch}*.sketch", (err, files) ->
    return cb() if !files.length

    tasks = files.map (entry) ->
      if entry.indexOf('svg_sprites.sketch') != -1
        imageDest = src.svgSprites
        options =
          export: 'artboards'
          formats: 'svg'
      else
        imageDest = dest.images
        options =
          export: 'slices'

      gulp.src entry
        .pipe $.sketch(options)
        .pipe imagemin()
        .pipe gulp.dest(imageDest)

    es.merge(tasks).on('end', cb)
