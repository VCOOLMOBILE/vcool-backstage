fsCSON = require 'fs-cson'
configPath = G.basePath.config

try
  devConfig = fsCSON.readFileSync "#{configPath}dev.cson"
  $.env { vars: devConfig }
catch err
  logger.warn(err.toString())

taskname = argv._[0]

if taskname == 'save' || argv.testsave
  argv.env = 'prod'
  argv.minify = false
  argv.relative = true
  argv.archive = true
else
  argv.env ?= 'dev'
  argv.minify ?= false
  argv.relative ?= false
  argv.archive ?= false
