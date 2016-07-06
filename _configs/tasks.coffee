#--------------------------------
#------ Support definition ------
#--------------------------------

# Config for browserSync
exports.browser_support = [
  "ie >= 9"
  "ie_mob >= 10"
  "ff >= 30"
  "chrome >= 34"
  "safari >= 7"
  "opera >= 23"
  "ios >= 7"
  "android >= 4.4"
  "bb >= 10"
]

# Config for
exports.images_config =
  pngquant:       true
  optipng:        true
  zopflipng:      true
  advpng:         true
  jpegRecompress: true
  jpegoptim:      true
  mozjpeg:        true
  gifsicle:       true
  svgo:           true