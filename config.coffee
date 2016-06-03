#--------------------------------
#----- Project definition -------
#--------------------------------

# directory where your developing stuff
project_dev     = "../app"
# directory where you want to publish the project
project_src     = "../www"
# sample code directory
project_sample  = "./app"

#--------------------------------
#------ Path configuration ------
#--------------------------------
exports.path =
  dist:
    src:    project_src
    css:    project_src + '/css/'
    js:     project_src + '/js/'
    images: project_src + '/img/'
    vendors:project_src + '/vendors'
  ghpage:
    src: '../gh-pages/**/*'
  browser:
    refresh: [project_dev + "/*.html",  project_dev + "/js/*.js"]
  scss:
    dev:    project_dev + '/assets__css/*.scss'
    watch:  project_dev + '/assets__css/**/*.scss'
  js:
    watch:  project_dev + '/assets__js/**/*.js'
    ignore: project_dev + '/assets__js/vendors/**/*'
  swig:
    dev:    project_dev + '/pages/**/*.html'
    watch: [project_dev + "/partials/**/*.html",  project_dev + "/pages/**/*.html"]
  image:
    dev:    project_dev + '/assets__img/*'
  data:
    src:    project_dev + '/content/*'
    app:    project_dev + '/content/app.json'
    json:   project_dev + '/content/**/*.json'
    yaml:   project_dev + '/content/**/*.yml'
  vendors:  project_dev + '/vendors/**'

#--------------------------------
#------ Task Bundle -------------
#--------------------------------

exports.taskBundle =
  watch: [
    'watch:browserSync'
    'watch:sass'
    'watch:swig'
    'watch:babel'
    'watch:swig'
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

#--------------------------------
#------ Init configuration ------
#--------------------------------
exports.configPath =
  init: [
    project_sample + "/**",
    "!" + project_sample + "/js/*/**",
    "!" + project_sample + "/pages/*/**",
    "!" + project_sample + "/partials/*/**",
  ]