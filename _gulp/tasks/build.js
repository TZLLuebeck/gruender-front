var gulp = require('gulp');
//manifest does double revs right now..
gulp.task('build', [ 'coffee', 'css', 'images', 'jade']);
