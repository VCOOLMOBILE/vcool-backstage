lazypipe = require('lazypipe')

module.exports = lazypipe()
  .pipe($.imagemin, {
    svgoPlugins: [
      { cleanupIDs: false}
      { mergePaths: false }
    ]
  })
