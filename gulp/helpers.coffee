{ basePath, src } = G

fs = require 'fs'
yaml = require 'js-yaml'
glob = require 'glob'
assign = require 'lodash/assign'

readYml = (dir, fileName, cb) ->
  filePath = "#{dir}#{fileName}.yml"

  try
    fs.accessSync(filePath, fs.F_OK)
    yaml.safeLoad fs.readFileSync(filePath, 'utf-8')
  catch err
    logger.alert "#{filePath} not found"
    cb(err) if cb?

checkExistence = (pattern, task, directory) ->
  glob pattern, (err, files) ->
    if !files.length
      logger.warn "#{task}: no files matches under #{directory}"

onError = (err) ->
  $.notify.onError(
    title:    'Gulp'
    subtitle: 'Failure!'
    message:  "Error: <%= error.message %>"
    sound:    'Hero'
  )(err)
  @emit?('end')

logger.alert = (msg) -> G.onError(new Error(msg))

assign(G, { readYml, checkExistence, onError })
