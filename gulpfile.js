(function() {
  var coffee, gulp, gutil, server, watch;

  gulp = require('gulp');

  gutil = require('gulp-util');

  coffee = require('gulp-coffee');

  watch = require('gulp-watch');

  server = require('gulp-develop-server');

  gulp.task('coffee', function() {
    return gulp.src(['./src/**/*.coffee', '!./src/gulpfile.coffee', '!./src/test/**/*.coffee']).pipe(coffee({
      bare: false
    }).on('error', gutil.log)).pipe(gulp.dest('./build'));
  });

  gulp.watch('./src/**/*.coffee', function(files, cb) {
    gulp.start('coffee');
    return server.restart();
  });

  gulp.watch('./src/gulpfile.coffee', function() {
    return gulp.src('./src/gulpfile.coffee').pipe(coffee({
      bare: false
    }).on('error', gutil.log)).pipe(gulp.dest('./'));
  });

  gulp.watch('./src/test/**/*.coffee', function() {
    return gulp.src('./src/test/**/*.coffee').pipe(coffee({
      bare: false
    }).on('error', gutil.log)).pipe(gulp.dest('./test'));
  });

  gulp.task('default', function() {
    return server.listen({
      path: './build/index.js'
    });
  });

}).call(this);
