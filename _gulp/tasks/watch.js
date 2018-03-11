var gulp       = require('gulp'),
    config     = require('../config'),
    gutil      = require('gulp-util'),
    browserSync = require('browser-sync'),
    reload      = browserSync.reload;
gulp.task('watch', function() {
  global.isWatching = true;
  gulp.watch('src/javascripts/**/*.{js,coffee}', ['coffee']);
  gulp.watch(['src/stylesheets/*.scss', 'src/stylesheets/*.sass'], ['css']);
  gulp.watch('src/views/**/*.jade', ['jade', reload]);
  gulp.watch('src/images/*', ['images', reload]);
});
