var gulp  = require('gulp'),
rev       = require('gulp-rev'),
manifest  = require('gulp-rev-rails-manifest'),
config    = require('../config.js'),
DEST      = config.public_root;

gulp.task('manifest', [ 'coffee', 'css', 'images', 'jade', 'copy-dep' ], function () {
    return gulp.src([DEST+'/stylesheets/*.css', DEST+'/javascripts/*.js'], { base: DEST })
      .pipe(rev())
      .pipe(gulp.dest(DEST))  // write rev'd assets to build dir
      .pipe(manifest())
      .pipe(gulp.dest(DEST)); // write manifest to build dir
});
