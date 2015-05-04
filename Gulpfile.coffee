gulp      = require 'gulp'
run       = require 'gulp-run'
rename    = require 'gulp-rename'

destDir = './scripts/skeleton_generator/'
skeletonFile = 'skeleton.less'
slotsFile = 'slots.less'

gulp.task 'generate-skeletons', ->
  run('python main.py', {cwd: destDir, silent: true}).exec()
  .pipe(rename(skeletonFile))
  .pipe(gulp.dest(destDir))

gulp.task 'generate-slots', ['generate-skeletons'], ->
  run('cat '+skeletonFile+'|grep \'^\\s*\\.\'|sed \'s/);/) {}/\'|sed \'s/^[ \\t]*//\'', {cwd: destDir, silent: true}).exec()
  .pipe(rename(slotsFile))
  .pipe(gulp.dest(destDir))

gulp.task 'foundation', ['generate-slots']

gulp.task 'themes', ->

gulp.task 'books', ->

gulp.task 'styles', ['foundation', 'themes', 'books']