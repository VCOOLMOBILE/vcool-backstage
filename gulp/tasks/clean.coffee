{ basePath } = G
del = require 'del'
vinylPaths = require 'vinyl-paths'

gulp.task 'clean', ->
  gulp.src basePath.dest
    .pipe vinylPaths(del)
