const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')
const webpack = require('webpack')

environment.loaders.append('vue', vue)

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default'],
  })
)


// This may be able to be removed after this is merged: https://github.com/projectblacklight/blacklight/pull/1934
// and a new version of blacklight-frontend is published
const sassLoader = environment.loaders.get('sass')
sassLoader.use.find(item => item.loader == "sass-loader").options.includePaths = [
  'node_modules/blacklight-frontend/app/assets/stylesheets'
];


module.exports = environment
