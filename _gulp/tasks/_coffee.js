var gulp = require('gulp'),
  uglify = require('gulp-uglify'),
  gutil = require('gulp-util'),
  concat = require('gulp-concat'),
  config = require('../config'),
  coffee = require('gulp-coffee'),
  ngAnnotate = require('gulp-ng-annotate'),
  merge = require('merge-stream'),
  plumber = require( 'gulp-plumber' ),
  newer = require('gulp-newer'),
  notify     = require('gulp-notify'),
  gulpif = require('gulp-if'),
  log_rm = require("gulp-remove-logging");
var DEST = config.public_root;

//Resolve dependencies and compress sources
gulp.task('coffee', function() {
  var coffeeFiles = gulp.src('src/javascripts/**/*.coffee')
    .pipe(coffee({
      bare: true
    }).on('error', gutil.log));

  var javascriptFiles = gulp.src('src/javascripts/**/*.js');

  merge(coffeeFiles, javascriptFiles)
    .pipe(newer(DEST + '/javascripts/app-bundle.js'))
    .pipe(ngAnnotate())
    .pipe(concat('/javascripts/app-bundle.js'))
    .pipe(plumber({
          errorHandler: notify.onError({
            title: 'Gulp',
            message: '<%= error.message %>',
          })
        }))
    .pipe(gulpif(config.env == 'production', log_rm()))
    .pipe(gulpif(config.env == 'production', uglify()))
    .pipe(gulp.dest(DEST));
});
