const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: {
    //app: './src/javascripts/app.coffee',
    vendor: ['jquery', '@angular/core', '@uirouter/angularjs', 'restangular', 'ngstorage', 'angular-permission', 'ng-file-upload', 'angularjs-toaster']
    },
  output: {
    filename: '[name].bundle.js',
    path: path.join(__dirname, '../public/assets/javascripts')
  },
  resolve: {
    extensions: ['*', '.ts', '.js', '.coffee']
  },
  plugins: [
    new webpack.optimize.CommonsChunkPlugin({name: "vendor", filename: "vendor-bundle.js"})
  ],
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: [
          'awesome-typescript-loader'
        ]
      },
      {
        test: /\.coffee$/,
        use: [
          'coffee-loader'
        ]
      }
    ]
  }
};