{ basePath, src, dest, checkExistence } = G

path = require 'path'
assign = require 'lodash/assign'
genPugHelpers = require "#{basePath.libs}compile/pug"
glob = require 'glob'
es = require 'event-stream'
fs = require 'fs'
rs = require 'run-sequence'

pugOptions =
  pretty: !argv.minify
  basedir: "#{basePath.src}/view"

getData = (entry) ->
  pagePath = entry.replace(src.pages, '').replace('.pug', '')
  pageLevel = pagePath.split('/').length - 1

  pageLevelString = []
  pageLevelString.push('../') for i in [0...pageLevel] by 1
  pageLevelString = pageLevelString.join('')

  specificData =
    currentPath: pagePath
    currentPage: pagePath.replace(/\//g, '_')
    pageLevelString: pageLevelString

  return assign(specificData, genPugHelpers(specificData))

rootToRelativeReplacerFn = (pageLevelString) ->
  (match, extraAttrs, href) ->
    href = href.replace('/', '')
    index = ''

    try
      fs.accessSync("#{src.pages}#{href}.pug", fs.F_OK)
    catch err
      index = if href.length && href.indexOf('/') < 0 then '/index' else 'index'

    "a #{extraAttrs}href=\"#{pageLevelString}#{href}#{index}.html\""

gulp.task 'compile:pug', (cb) ->
  pat = "#{src.pages}**/!(_*).pug"
  checkExistence(pat, 'pug', src.pages)

  glob pat, (err, files) ->
    return cb() if !files.length

    tasks = []

    files.forEach (entry) ->
      return if argv.archive && entry.indexOf('dev-sample') >= 0
      pathClips = path.dirname(entry).split('pages/')
      page = pathClips[1] || ''
      data = getData(entry)
      replacer = rootToRelativeReplacerFn(data.pageLevelString)

      stream = gulp.src(entry)
        .pipe $.data(data)
        .pipe $.pug(pugOptions)
        .pipe $.if(argv.relative, $.replace(/a ([^>]*)href="(\/[^\/\"\'][^\"\']*|\/)"/g, replacer))
        .pipe gulp.dest(dest.pages + page)

      tasks.push stream

    es.merge(tasks).on('end', ->
      if argv.sitemap
        rs('sitemap', cb)
      else
        cb()
    )
