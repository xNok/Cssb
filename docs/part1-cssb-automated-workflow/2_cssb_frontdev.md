# Front-end development with cssb

## Directory structure

I recommend that you use following structure inside the __frontdev__ folder, but you can easily changed that configuration with the config.coffee file. To simplifies organizing large websites CSSB support by default a single level subdirectory.

Keeping a simple lvl of subdirectory let navigate so easily into your project. This is one reason why I choose to prefix assets folders with **assets__** rather than using a directory.

```javascript
+-- assets__css     // CSS, SCSS, SASS resources
+-- assets__img     // images resources
+-- assets__js      // JS resources
+-- content         // JSON, text, HTML, Markdown blocks that can be edited separately from the page or layout
+-- layouts          // All page scaffolds
+-- pages           // Web pages
+-- partials        // contain reusable HTML that an be include or used as a macro
+-- vendors         // external libraries
```

## Personalised the directory structure

First, Open the file *config.coffee* and define your project structure :

```coffeescript
# directory where you want to publish the project
frontdev_outputdir       = "../www"
# your frontend developement directory
frontdev_inputdir  = "../frontdev"
# your project documentation directory
project_doc       = "../docs"
```

Then you can change the output directories via the variable **path_frontdev** :

```coffee
exports.path_frontdev.out =
  src:      frontdev_outputdir + '/'
  css:      frontdev_outputdir + '/css/'
  img:      frontdev_outputdir + '/img/'
  js:       frontdev_outputdir + '/js/'
  html:     frontdev_outputdir + '/'
  vendors:  frontdev_outputdir + '/vendors/'
```

Finally you can define the structure of your dev directory. These variables are use by the gulp task with the following rules :

* __src__:      directory definition
* __dev__:      development files to compile
* __watch__:    development files to watch
* __ignore__:   development files to ignore

```coffee
exports.path_frontdev.in =
  src:      frontdev_inputdir + "/"
  css:
    src:    frontdev_inputdir + "/assets__css/"
    dev:    frontdev_inputdir + '/assets__css/*.scss'
    watch:  frontdev_inputdir + '/assets__css/**/*.scss'
  img:
    src:    frontdev_inputdir + "/assets__img/"
    dev:    frontdev_inputdir + '/assets__img/*'
    *****
```

## HTML

for the HTML developement the __cli__ to remember is :

> gulp frontdev:compile:swig2html
> OR ...
> gulp swig

With Cssb you can use the power of the [Swig]() template engine. In this part we would focus ont the 4 folders that you can use for store your html and build your pages.

```java
 +-- contents
 |`+-- app.json
 | +-- [] subdirectories
 +-- layouts
 +-- pages
 |`+-- index.html
 | +-- [] subdirectories
 +-- partials
 |`+-- [] subdirectories
```

### templating

The first step is to create one or several layout for your site pages. Lets have a look to the default template file.

```html
<!DOCTYPE html>
<html>

<head lang="FR">

    <title>CSSB</title>

    <!-- params -->
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="favicon.ico">
    <link rel="apple-touch-icon" href="apple-touch-icon.png">

    <!-- SEO -->
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">

    <!-- Vendors -->

    <!-- build:css css/styles.min.css -->
    <link rel="stylesheet" type="text/css" media="screen" href="css/app.css">
    <!-- endbuild -->
</head>

<body>
    <div id="l-container">
        <header id="l-header">
            {% include "../partials/header.html" %}
        </header>

        <main id="l-content">
            {% block content %}{% endblock %}
        </main>

        <footer id="l-footer">
            {% include "../partials/footer.html" %}
        </footer>
    </div>

    <!-- build:js js/scripts.min.js -->
    <script src="js/app.js"></script>
    <!-- endbuild -->
</body>

</html>
```

Then to apply this template for your page use the following code to insert your page inside the __block__ named **content**

```html
{% extends '..\layouts\main.html' %}
{% block content %}

{% endblock %}
```

Let's have an in depth look at what you can find in this template.

1. Style asset management tag

>   <!-- build:css css/styles.min.css -->
>   <link rel="stylesheet" type="text/css" media="screen" href="css/app.css">
>   <!-- endbuild -->

This tag works with the cli `gulp useref` and will replace all the links by a single minify stylesheet defined in the tag **css/styles.min.css**.

2. include partials

> {% include "../partials/header.html" %}

This tag works with the cli `gulp swig` and will copy the content of the partial at this location.

3. block definition

> {% block content %}{% endblock %}

this tag works with the cli `gulp swig` and will paste the content or any content inside another block statement called **content**

> {% extends '..\layouts\main.html' %}
> {% block content %}
> this will be copied into ..\layouts\main.html inside the content block
> {% endblock %}

4. Script asset management

> <!-- build:js js/scripts.min.js -->
> <script src="js/app.js"></script>
> <!-- endbuild -->

This tag works with the cli `gulp useref` and will replace all the scripts by a single minify js file defined in the tag **js/scripts.min.js*.

5. Temporary information

> <!-- build:remove -->
> something you want to remove when you build the final version
> <!-- endbuild -->

This tag is not in the template but it is very practical to erase something which is useful only during the development process. This tag works with the cli `gulp useref`.