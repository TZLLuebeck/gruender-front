var gulp        = require('gulp');
var browserSync = require('browser-sync');
var config      = require('../config');
var DEST        = config.public_root;
// Static Server + watching jade, coffee, scss files, images are reloaded by
// the watch task
gulp.task('serve', ['build']
  //,
// function() {
//    browserSync({
//        proxy: 'http://localhost:3000',
//        files: [DEST+'/**/*.{js,css,html}']
//    });
//  }
);
