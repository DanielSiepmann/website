var config = require('./gulp-config.json'),
    gulp = require('gulp'),
    sass = require('gulp-sass'),
    notify = require('gulp-notify'),
    autoprefix = require('gulp-autoprefixer'),
    rename = require('gulp-rename'),
    cleanCSS = require('gulp-clean-css'),
    bower = require('gulp-bower'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat');

gulp.task('bower', function() {
    return bower()
        .pipe(gulp.dest(config.assets.bower))
});

gulp.task('sass', function() {
    return gulp.src(config.scss.files)
        .pipe(sass({
            includePaths: [config.assets.bower]
        }).on("error", notify.onError(function(error) {
            return "Error: " + error.message;
        })))
        .pipe(autoprefix('last 2 version'))
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(cleanCSS())
        .pipe(gulp.dest(config.scss.dest));
});

gulp.task('scripts', function() {
    gulp.src([
            config.assets.bower + 'jquery/dist/jquery.min.js',
            config.assets.bower + 'bootstrap/dist/bootstrap.min.js',
            './Assets/JavaScript/*.js',
        ])
        .pipe(concat('Main.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest(config.scripts.dest))
});

gulp.task('default', ['bower', 'sass', 'scripts']);
