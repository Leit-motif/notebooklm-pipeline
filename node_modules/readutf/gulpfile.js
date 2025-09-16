var gulp = require('gulp');
var sequence = require('gulp-sequence');
require('file-manifest').generate('./gulp', ['*.js', '!config.js']);
gulp.task('travis', sequence(['lint', 'cover', 'int'], 'codeclimate'));
gulp.task('test', ['cover', 'int']);
gulp.task('default', ['lint', 'test']);
