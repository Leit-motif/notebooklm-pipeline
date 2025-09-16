const gulp = require('gulp');
const sequence = require('gulp-sequence');
require('file-manifest').generate('./gulp', { match: ['*.js', '!config.js'] });
gulp.task('travis', sequence(['default'], 'codeclimate'));
gulp.task('test', sequence(['clean'], ['cover']));
gulp.task('default', sequence(['lint', 'clean'], ['cover']));

