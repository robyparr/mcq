const purgecss = require('@fullhuman/postcss-purgecss')({
  content: [
    './app/views/**/*.html',
    './app/views/**/*.html.*',
    './javascript/**/*.*',
  ],
  defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
})

module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-nested'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    require('tailwindcss')('./app/javascript/src/tailwind.js'),
    ...process.env.NODE_ENV === 'production'
      ? [purgecss]
      : [],
  ]
}
