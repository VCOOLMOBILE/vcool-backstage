# Prepare
require './gulp/aliases'
require './gulp/paths-static'
require './gulp/helpers'
require './gulp/set-env'
require './gulp/paths-dynamic'

# better gulp.src for error handling
_gulpsrc = gulp.src

gulp.src = ->
  _gulpsrc.apply(gulp, arguments)
    .pipe $.plumber
      errorHandler: G.onError

# Load sub tasks
require('require-dir')('./gulp/tasks', { recurse: true })

# Top-level tasks
run = require 'run-sequence'

gulp
  # .task 'images',  (cb) -> run(['images:sketch', 'images:copy'], 'images:svg-sprites', cb)
  .task 'images',  (cb) -> run(['images:copy'], cb)
  .task 'compile', (cb) -> run('compile:variables', ['compile:pug', 'compile:sass', 'compile:coffee'], cb)
  .task 'main',    (cb) -> run('clean', 'images', 'compile', cb)

gulp
  .task 'default', (cb) -> run('main', 'dev-server', cb)
  .task 'save',    (cb) -> run('main', 'save:archive', cb)

logger.info "current environment: #{argv.env}"
