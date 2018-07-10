{ basePath, dest } = G

gulp.task 'sitemap', ->
  gulp.src "#{dest.pages}**/*.html"
    .pipe $.sitemap(
      siteUrl: require("#{basePath.data}info").site.url
    )
    .pipe gulp.dest(dest.pages)
