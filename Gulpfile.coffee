gulp      = require 'gulp'
run       = require 'gulp-run'
rename    = require 'gulp-rename'
watch = require 'gulp-watch'
gutil = require 'gulp-util'
print = require 'gulp-print'
reporter = require 'gulp-less-reporter'
less = require 'gulp-less'
changed = require 'gulp-changed'
lessDependents = require 'gulp-less-dependents'
gulpFilter = require 'gulp-filter'

destDir = './scripts/skeleton_generator/'
skeletonFile = '../skeleton.less'
slotsFile = 'slots.less'


gulp.task 'generate-skeletons', ->
  run('python main.py', {cwd: destDir, silent: true}).exec()
  .pipe(rename(skeletonFile))
  .pipe(gulp.dest(destDir))

gulp.task 'generate-slots', ['generate-skeletons'], ->
  run('cat '+skeletonFile+'|grep \'^\\s*\\.\'|sed \'s//) {}/\'|sed \'s/^[ \\t]*//\'', {cwd: destDir, silent: true}).exec()
  .pipe(rename(slotsFile))
  .pipe(gulp.dest(destDir))

gulp.task 'books', ->
  gulp.src(['less/books/**/*.less', '!less/books/**/variables.less'])
    #.pipe(changed('css/books/', {extension: '.css'}))
    .pipe(less())
    .pipe(gulp.dest('css/books/'))
    .on('error', reporter)
    .pipe(print())

gulp.task 'watchThemes', ->
  gulp.src('less/books/**/*.less')
    .pipe(watch('less/books/**/*.less'))
    .pipe(gulpFilter('*', '!less/books/**/variables.less'))
    .pipe(less())
    .pipe(gulp.dest('css/books/'))
    .on('error', reporter)
    .pipe(print())

gulp.task 'watchBooks', ->
  gulp.src('less/books/**/*.less')
    .pipe(watch('less/books/**/*.less'))
    .pipe(less())
    .pipe(gulp.dest('css/books/'))
    .on('error', reporter)
    .pipe(print())

gulp.task 'styles', ['foundation', 'themes', 'books']










