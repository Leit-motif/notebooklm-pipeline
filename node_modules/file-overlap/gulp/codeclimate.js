const gulp = require('gulp');
const codeclimate = require('gulp-codeclimate-reporter');

gulp.task('codeclimate', () => {
  if (process.version.indexOf('v4') > -1) {
    gulp.src('coverage/lcov.info', { read: false })
      .pipe(codeclimate({
        token: '76ac808ebeb3bc896623135e2653c2c2a4c218b0af6b3e61a515426b9d122991'
      }));
  }
});

