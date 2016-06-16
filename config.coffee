#--------------------------------
#----- Project definition -------
#--------------------------------

# directory where you want to publish the project
project_src       = "../www"
# your frontend developement directory
project_frontdev  = "../frontdev"
# your project documentation directory
project_doc       = "../docs"

# sample code directory
frontdev_sample   = "./frontdev"
gitbook_sample    = "./gitbook"

#--------------------------------
#------ Path configuration ------
#--------------------------------

# define the documentation directory stucture
exports.path_docs =
  in:
    src:      project_doc
    watch:    project_doc + '/**/*.md'
  out:
    pdf:      project_doc + 'Book/book.pdf'
    website:  project_doc + 'Book/web/'
    ePub:     project_doc + 'Book/book.epub'
    mobi:     project_doc + 'Book/book.mobi'

# define the frontend Output directory structure
exports.path_frontdev =
  in:
    src:      project_frontdev + "/"
    scss:
      dev:    project_frontdev + '/assets__css/*.scss'
      watch:  project_frontdev + '/assets__css/**/*.scss'
    js:
      watch:  project_frontdev + '/assets__js/**/*.js'
      ignore: project_frontdev + '/assets__js/vendors/**/*'
    swig:
      dev:    project_frontdev + '/pages/**/*.html'
      watch: [
        project_frontdev + "/partials/**/*.html",
        project_frontdev + "/pages/**/*.html",
        project_frontdev + "/layout/*.html"
      ]
    image:
      dev:    project_frontdev + '/assets__img/*'
    data:
      src:    project_frontdev + '/contents/'
      app:    project_frontdev + '/contents/app.json'
      json:   project_frontdev + '/contents/**/*.json'
      yaml:   project_frontdev + '/contents/**/*.yml'
    vendors:  project_frontdev + '/vendors/**'
  out:
    src:    project_src + '/'
    css:    project_src + '/css/'
    js:     project_src + '/js/'
    images: project_src + '/img/'
    vendors:project_src + '/vendors'  

exports.path_ghpage =
  in: project_src + '/**/*'

#--------------------------------
#------ Init configuration ------
#--------------------------------
exports.path_init =
  website: [
    frontdev_sample + "/**",
    "!" + frontdev_sample + "/js/*/**",
    "!" + frontdev_sample + "/pages/*/**",
    "!" + frontdev_sample + "/partials/*/**",
  ]
  gitbook: gitbook_sample + "/**/**"

#--------------------------------
#------ Task Bundle -------------
#--------------------------------

exports.taskBundle =
  watch: [
    'watch:browserSync'
    'watch:sass'
    'watch:swig'
    'watch:js'
    'watch:json'
    'watch:image'
  ]
  run: [
    'compile:swig'
    'compile:sass'
    'compile:js'
    'copy:vendors'
    'minify:image'
    'watch'
  ]
  lint: ['lint:Json']
  dist: [
    'compile:swig'
    'minify:css'
    'minify:js'
    'minify:image'
  ]

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