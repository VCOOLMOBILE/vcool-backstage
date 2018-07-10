fs = require 'fs'
rs = require 'run-sequence'
bs = require 'browser-sync'

gulp.task 'save:viewer', ->
  timeMachine.compile(G.basePath.archive)

  bs
    server:
      baseDir: G.basePath.archive
      index: 'index.html'
    port: process.env.dev_port || 9000
    open: true
    extensions: 'html'
