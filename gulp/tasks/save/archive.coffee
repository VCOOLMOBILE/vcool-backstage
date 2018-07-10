moment = require 'moment'
git = require 'git-rev' # to get current branch name
del = require 'del'
runSequence = require 'run-sequence'

{ trim } = require 'strman'
{ dest, archive } = G.basePath

gulp.task 'clean-archive', (cb) ->
  del(archive)

gulp.task 'save:archive', (cb) ->
  git.branch (branch) ->
    folderName = [
      moment().format('YYYY-MM-DD-HH-mm')
      if argv.o then 'o' else 'i'
      branch.replace(/\-/g, '_').replace(/\//, '__')
    ]

    folderName.push encodeURIComponent(trim(argv.m)) if argv.m?
    folderName = folderName.join('-')

    gulp.src "#{dest}/**/*"
      .pipe gulp.dest("#{archive}/#{folderName}")
      .on 'end', cb
