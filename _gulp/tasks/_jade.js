'use strict';
var gulp  = require('gulp'),
    jade  = require('gulp-jade'),
    changed = require('gulp-changed'),
    cached = require('gulp-cached'),
    gulpif = require('gulp-if'),
    gutil = require('gulp-util'),
    config = require('../config'),
    newer  = require('gulp-newer'),
    DEST   = config.public_root;



// Compile jade files to root
gulp.task('jade', function() {
  return gulp.src(['src/views/**/*.jade'])
    .pipe(newer(DEST+'/views'))
    //only pass unchanged main files and all the partials
    .pipe(changed(DEST+'/views', {extension: '.html'}))
    //filter out unchanged partials, but it only works when watching
    .pipe(gulpif(global.isWatching, cached('jade')))
    .pipe(jade())
    .on('error', gutil.log)
    .pipe(gulp.dest(DEST+'/views'));
});
