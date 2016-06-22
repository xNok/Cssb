#--------------------------------
#----- TaskBundle definition  ----
#--------------------------------
exports.run = [
    'compile:swig'
    'compile:sass'
    'compile:js'
    'copy:vendors'
    'minify:image'
    'watch'
  ]

exports.dist = [
    'compile:swig'
    'minify:css'
    'minify:js'
    'minify:image'
  ]