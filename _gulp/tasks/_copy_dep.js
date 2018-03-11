var gulp       = require('gulp'),
    uglify     = require('gulp-uglify'),
    concat     = require('gulp-concat'),
    gutil      = require('gulp-util'),
    bowerhack  = require('main-bower-files'),
    gulpFilter = require('gulp-filter'),
    rename     = require('gulp-rename'),
    config     = require('../config'),
    newer      = require('gulp-newer'),
    sourcemaps = require('gulp-sourcemaps'),
    postcss    = require('gulp-postcss'),
    autoprefixer = require('autoprefixer'),
    mqpacker   = require('css-mqpacker'),
    csswring   = require('csswring'),
    gulpif     = require('gulp-if'),
    DEST       = config.public_root;



gulp.task('copy-dep', function() {
  var jsFilter = gulpFilter('**/*.js', {restore: true});
  var cssFilter = gulpFilter('**/*.css', {restore: true});
  var fontRegex = /\.(eot|svg|ttf|woff|woff2|otf)$/;
  var processors = [
      autoprefixer({ browsers:'last 1 version' }),
      mqpacker,
      csswring
  ];
  return gulp.src(bowerhack())
    .pipe(jsFilter)
    .pipe(newer(DEST+'/javascripts/vendor.min.js'))
    .pipe(gulpif(config.env == 'production', uglify({mangle: false, compress: false})))
     .pipe(concat('javascripts/vendor.min.js'))
     .pipe(gulp.dest(DEST))
    .pipe(jsFilter.restore)
    .pipe(cssFilter)
    .pipe(newer(DEST+'/stylesheets/vendor.min.css'))
    .pipe(sourcemaps.init())
    .pipe(postcss(processors))
    .pipe(concat('stylesheets/vendor.min.css'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(DEST))
    .pipe(cssFilter.restore)
    .pipe(rename(function(path) {
       if (fontRegex.test(path.extname)) {
         path.dirname = '/fonts';
       }
    }))
    //write fonts to destination
    .pipe(gulp.dest(DEST));
});
