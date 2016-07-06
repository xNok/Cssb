#--------------------------------
#----- Folder definition  -------
#--------------------------------
# directory where you want to publish the project
frontdev_outputdir       = "../www"
# your frontend developement directory
frontdev_inputdir  = "../frontdev"
# your project documentation directory
project_doc       = "../docs"

# sample code directory
frontdev_sample   = "./_boilerplates/frontdev"
gitbook_sample    = "./_boilerplates/gitbook"

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Table of Content
# 
# 1. Front dev Paths
# 2. Documentation
# 3. Pulishing
# 4. Sample configuration
# 
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

#--------------------------------
#-----1. Front dev Paths ---------
#--------------------------------

exports.path_frontdev = {}

### Dev directory structure

 +-- assets__css
 |`+-- base
 | +-- modules
 | +-- themes
 | +-- app.css
 +-- assets__img
 | +-- [] subdirectories
 +-- assets__js
 |`+-- [] subdirectories
 +-- contents
 |`+-- app.json
 | +-- [] subdirectories
 +-- layouts
 +-- pages
 |`+-- [] subdirectories
 +-- partials
 |`+-- [] subdirectories
 +-- vendors
 |`+-- [] subdirectories
###
exports.path_frontdev.in =
  src:      frontdev_inputdir + "/"
  css:
    src:    frontdev_inputdir + "/assets__css/"
    dev:    frontdev_inputdir + '/assets__css/*.scss'
    watch:  frontdev_inputdir + '/assets__css/**/*.scss'
  img:
    src:    frontdev_inputdir + "/assets__img/"
    dev:    frontdev_inputdir + '/assets__img/*'
  js:
    src:    frontdev_inputdir + "/assets__js/"
    dev:    frontdev_inputdir + '/assets__js/**/*.js'
    watch:  frontdev_inputdir + '/assets__js/**/*.js'
  contents:
    src:    frontdev_inputdir + '/contents/'
    app:    frontdev_inputdir + '/contents/app.json'
    json:   frontdev_inputdir + '/contents/**/*.json'
    yaml:   frontdev_inputdir + '/contents/**/*.yml'
  html:
    layouts:
      src:    frontdev_inputdir + "/layouts/"
      dev:    frontdev_inputdir + "/layouts/*.html"
    pages:
      src:    frontdev_inputdir + "/pages/"
      dev:    frontdev_inputdir + "/pages/**/*.html"
    partials:
      src:    frontdev_inputdir + '/pages/**/*.html'
      dev:    frontdev_inputdir + '/pages/**/*.html'
    watch: [
      frontdev_inputdir + "/partials/**/*.html"
      frontdev_inputdir + "/pages/**/*.html"
      frontdev_inputdir + "/layouts/*.html"
    ]
  vendors:
    src:    frontdev_outputdir + '/vendors/'  

### Prod directory stryctures

 +-- css
 +-- img
 | +-- [] subdirectories
 +-- js
 +-- vendors
 |`+-- [] subdirectories
 +-- maps
 |`+-- app.css.map
 |`+-- app.js.map
 +-- [] *.html
###

# define the frontend Output directory structure
exports.path_frontdev.out =
  src:      frontdev_outputdir + '/'
  css:      frontdev_outputdir + '/css/'
  img:      frontdev_outputdir + '/img/'
  js:       frontdev_outputdir + '/js/'
  html:     frontdev_outputdir + '/'
  vendors:  frontdev_outputdir + '/vendors/'
  maps:     '../maps/'

#--------------------------------
#-----2. Documentation -----------
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

#--------------------------------
#-----3. Pulishing ---------------
#--------------------------------

exports.path_ghpage =
  in: frontdev_outputdir + '/**/*'

#--------------------------------
#-----4. Sample configuration ----
#--------------------------------

exports.path_init =
  website: [
    frontdev_sample + "/**",
    "!" + frontdev_sample + "/assets__js/*/**",
    "!" + frontdev_sample + "/pages/*/**",
    "!" + frontdev_sample + "/partials/*/**",
  ]
  gitbook: gitbook_sample + "/**/**"