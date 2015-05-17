gulp   = require 'gulp'
gutil  = require 'gulp-util'
coffee = require 'gulp-coffee'
watch  = require 'gulp-watch'
server = require 'gulp-develop-server'

gulp.task 'coffee', ->
	gulp.src([
		'./src/**/*.coffee',
		'!./src/gulpfile.coffee',
		'!./src/test/**/*.coffee'
	]).pipe(coffee({
		bare: false
	}).on('error', gutil.log)).pipe(gulp.dest('./build'))

gulp.watch './src/**/*.coffee', (files, cb) ->
		gulp.start 'coffee'
		server.restart()


gulp.watch './src/gulpfile.coffee', ->
	gulp.src('./src/gulpfile.coffee').pipe(coffee({
		bare: false
	}).on('error', gutil.log)).pipe(gulp.dest('./'))

gulp.watch './src/test/**/*.coffee', ->
	gulp.src('./src/test/**/*.coffee').pipe(coffee({
		bare: false
	}).on('error', gutil.log)).pipe(gulp.dest('./test'))

gulp.task 'default', ->
	server.listen({
		path: './build/index.js'
	})
