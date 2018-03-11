var path = require('path'),
    root = process.env.RAILS_ROOT || path.resolve('../'),
    env  = process.env.RAILS_ENV || 'development';

module.exports = {
  root: root,
  public_root: root+'/public/assets',
  test_root: root+'/frontend/tests/e2e/**/*.js',
  env: env
};

