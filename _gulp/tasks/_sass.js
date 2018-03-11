var gulp    = require('gulp'),
    sass    = require('gulp-sass'),
    gutil   = require('gulp-util'),
    concat     = require('gulp-concat'),
    postcss = require('gulp-postcss'),
    autoprefixer = require('autoprefixer'),
    mqpacker = require('css-mqpacker'),
    csswring = require('csswring'),
    sourcemaps = require('gulp-sourcemaps'),
    config  = require('../config'),
    newer   = require('gulp-newer'),
    checkCSS = require( 'gulp-check-unused-css' ),
    plumber = require( 'gulp-plumber' ),
    argv = require('minimist')(process.argv.slice(2)),
    DEST    = config.public_root;

//compass (scss)
gulp.task('sass', function() {
  var processors = [
    autoprefixer({ browsers:'last 1 version' }),
    mqpacker,
    csswring
  ];
  return gulp.src('src/stylesheets/*.scss')
    .pipe(newer(DEST+'/stylesheets/app.bundle.css'))
    .pipe(sourcemaps.init())
    .pipe(sass())
    .pipe(postcss(processors))
    .pipe(concat('/stylesheets/app.bundle.css'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(DEST));
});

var ignores = [/^alert-/, 'veil', 'loading-text', /^ui-select-/,
    'collapse-row-color-selected', /^fa-/, /^col-/, 'fa',  'form', 'navbar-right',
    'accordion-toggle', 'legend', 'form-label', 'indicator', 'collapsed'
];

function check() {
  return gulp.src([DEST+'/stylesheets/app.bundle.css', DEST+'/views/**/*.html'])
    .pipe( argv.exit ? gutil.noop() : plumber() )
    .pipe( checkCSS({ angular: true, globals: [ 'bootstrap@3.2.0' ], ignore: ignores }) )
    .pipe( argv.exit ? gutil.noop() : plumber.stop() );
}

gulp.task('unused-css', ['sass'], check);

gulp.task('css', ['sass', 'unused-css']);
