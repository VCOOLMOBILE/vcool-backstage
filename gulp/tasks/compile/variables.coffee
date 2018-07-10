{ basePath, src, checkExistence } = G

fs = require 'fs'
jsonSass = require 'json-sass'
source = require 'vinyl-source-stream'

gulp.task 'compile:variables_transform_source', ->
  gulp.src "#{basePath.config}shared.yml"
    .pipe $.yaml({ safe: true })
    .pipe gulp.dest('./.tmp/')

gulp.task 'compile:variables', ['compile:variables_transform_source'], ->
  jsonFile = './.tmp/shared.json'

  try
    fs.accessSync(jsonFile, fs.F_OK)
    fs.createReadStream(jsonFile)
      .pipe jsonSass(
        prefix:
          """// Generated from shared-config.json, DO NOT modify this directly.

          $theme: """
      )
      .pipe source(jsonFile)
      .pipe $.rename('_shared-config.scss')
      .pipe gulp.dest(src.styles)
      .on 'end', ->
        require('del')('./.tmp')

  catch err
    logger.alert 'some problem with compile:variables_transform_source'
