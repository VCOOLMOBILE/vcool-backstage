{ basePath, src, dest } = G

imagemin = require "#{basePath.libs}images/imagemin"

gulp.task 'images:copy', ->
  gulp.src "#{src.images}**/*.{jpg,jpeg,png,gif,svg,cur}"
    .pipe imagemin()
    .pipe gulp.dest(dest.images)
