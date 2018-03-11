var gulp     = require('gulp'),
    newer    = require('gulp-newer'),
    imagemin = require('gulp-imagemin'),
    config   = require('../config'),
    DEST     = config.public_root;
//images
gulp.task('images', function() {
    return gulp.src('src/images/**/*')
        .pipe(newer(DEST+'/images'))
        .pipe(imagemin({ optimizationLevel: 3, progressive: true, interlaced: true }))
        .pipe(gulp.dest(DEST+'/images'));
});
