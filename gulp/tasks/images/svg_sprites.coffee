{ basePath, src, dest } = G
rs = require 'run-sequence'

templateDir = "#{basePath.libs}images/svg-sprites/"

config =
  variables:
    mapname: 'icons'
  mode:
    css:
      dest: dest.images
      sprite: 'sprite-css.svg'
      layout: 'diagonal'
      bust: false
      render:
        scss:
          template: "#{templateDir}scss.pug.handlebars"
    symbol:
      dest: dest.images
      sprite: 'sprite.svg'
      layout: 'diagonal'
      render:
        demo:
          template: "#{templateDir}demo.pug.handlebars"
        inline:
          template: "#{templateDir}inline.pug.handlebars"
  svg:
    xmlDeclaration: false
    doctypeDeclaration: false

gulp.task 'images:svg-sprites:to-png', ->
  gulp.src("#{dest.images}sprite-css.svg")
    .pipe $.raster()
    .pipe $.rename({ extname: '.png' })
    .pipe gulp.dest(dest.images)

gulp.task 'images:svg-sprites:main', ->
  gulp.src("#{src.svgSprites}**/*.svg")
    .pipe $.svgSprite(config)
    .on 'error', G.onError
    .pipe $.if(/[.]demo$/, $.rename('src/view/pages/dev-sample/symbol.pug'))
    .pipe $.if(/[.]inline$/, $.rename('src/view/layouts/shared/_svg-sprites.pug'))
    .pipe $.if(/[.]scss$/, $.rename('src/sass/_svg-sprites-map.scss'))
    .pipe gulp.dest('.')

gulp.task 'images:svg-sprites', (cb) ->
  rs('images:svg-sprites:main', 'images:svg-sprites:to-png', cb)
