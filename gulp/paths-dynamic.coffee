assign = require 'lodash/assign'

resizedImagesFolder = 'assets/images/'
resizedImagesFolder += 'r/' if global.breakPointsConfig?

getPathFn = (folder, extension) ->
  (name, pageLevelString) ->
    if name.indexOf('//') < 0
      rel = if argv.relative then pageLevelString else '/'
      path = "#{rel}#{folder}#{name}"
    else
      path = name
    path += extension if name.indexOf(extension) < 0
    path

getImageUrl = (name, pageLevelString) ->
  rel = if argv.relative then pageLevelString else '/'
  "#{rel}#{resizedImagesFolder}#{name}"

getCssPath = getPathFn('assets/stylesheets/', '.css')
getJsPath = getPathFn('assets/javascripts/', '.js')

assign(G, { getImageUrl, getCssPath, getJsPath })
