#--------------------------------
#----- TaskBundle definition  ----
#--------------------------------
exports.watch = [
    'watch:browserSync'
    'watch:sass'
    'watch:swig'
    'watch:js'
    'watch:json'
    'watch:image'
  ]

exports.run = [
    'compile:swig'
    'compile:sass'
    'compile:js'
    'copy:vendors'
    'minify:image'
    'watch'
  ]

exports.lint = [
  'lint:Json'
]

exports.dist = [
    'compile:swig'
    'minify:css'
    'minify:js'
    'minify:image'
  ]