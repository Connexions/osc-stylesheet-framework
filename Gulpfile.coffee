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
subTask = require 'gulp-subtask'

destDir = './scripts/skeleton_generator/'
skeletonFile = '../skeleton.less'
slotsFile = 'slots.less'
themePath = 'css/themes/'
bookPath='css/books/'
themeNames = ['generic', 'hsphysics']
bookNames = ['prototype', 'hsphysics']

gulp.task 'generate-skeletons', ->
  run('python main.py', {cwd: destDir, silent: true}).exec()
  .pipe(rename(skeletonFile))
  .pipe(gulp.dest(destDir))

gulp.task 'generate-slots', ['generate-skeletons'], ->
  run('cat '+skeletonFile+'|grep \'^\\s*\\.\'|sed \'s//) {}/\'|sed \'s/^[ \\t]*//\'', {cwd: destDir, silent: true}).exec()
  .pipe(rename(slotsFile))
  .pipe(gulp.dest(destDir))

gulp.task 'foundation', ['generate-slots']


gulp.task = new SubTask('task') ->
  .src('less/themes/**/main.less')
  .pipe(changed('css/books/', {extension: '.css'}))
  .pipe(gulp.dest('css/books/'))
  .on('error', reporter)
  .pipe(print())

gulp.task 'books', ->
  gulp.src(['less/books/**/*.less', '!less/books/**/variables.less'])
    .pipe(changed('css/books/', {extension: '.css'})) //dont use this and generate all templates. Use this and generate books only, doesn't work if modifying themes
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










