var protractor  = require("gulp-protractor").protractor;
var gulp        = require('gulp');
var config      = require('../config');
var DEST        = config.test_root;
var gutil       = require('gulp-util');
var webdriver_standalone = require("gulp-protractor").webdriver_standalone;
var webdriver_update = require('gulp-protractor').webdriver_update;

gulp.task('webdriver_update', webdriver_update);

gulp.task('webdriver_standalone', webdriver_standalone);

gulp.task('tests', ['webdriver_update'], function(cb) {
  gulp.src([DEST])
    .pipe(protractor({
      configFile: config.root+'/frontend/protractor.conf.js',
      args: ['--baseUrl', 'http://127.0.0.1:3000']
    }))
    .on('error', gutil.log)
    .on('end', cb)
});


