'use strict'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    includes:
      files:
        src: ['src/jquery.tracking.coffee']
        dest: 'tmp'
        flatten: true
        cwd: '.'
        options:
          includeRegexp: /^(\s*)#=\s*include\s+(\S+)\s*$/
          silent: true
          banner: '# <% includes.files.dest %>'
    coffee:
      compile:
        files:
          'dist/jquery.tracking.js': 'tmp/jquery.tracking.coffee'
          'spec/test.spec.js': 'spec/test.spec.coffee'
    coffeelint:
      app:
        [ 'src/*.coffee' ]
    uglify:
      options:
        banner: '/*! <%= pkg.name %> v<%= pkg.version %> | <%= pkg.license %> */\n'
      build:
        files: 'dist/jquery.tracking.min.js': 'dist/jquery.tracking.js'
    compress:
      main:
        options:
          mode: 'gzip'
        files: [ {
          src: [ 'dist/jquery.tracking.min.js' ]
          dest: 'dist/jquery.tracking.js.gz'
        }]
    jasmine:
      specs:
        src: 'dist/jquery.tracking.js'
        options:
          specs: 'spec/*spec.js'
          vendor: [
            "bower_components/jquery/dist/jquery.min.js"
            "bower_components/js-cookie/src/js.cookie.js"
            "bower_components/js-url/url.min.js"
            "bower_components/jquery.debug/dist/jquery.debug.min.js"
            "bower_components/jasmine-jquery/lib/jasmine-jquery.js"
          ]
    watch:
      options: livereload: true
      files: '{src,spec}/*.coffee'
      tasks: 'default'

  # Loading dependencies
  for key of grunt.file.readJSON('package.json').devDependencies
    if key != 'grunt' and key.indexOf('grunt') == 0
      grunt.loadNpmTasks key

  grunt.registerTask 'default', [
    'includes'
    'coffeelint'
    'coffee'
    'jasmine'
    'uglify'
    'compress'
  ]

  grunt.registerTask 'test', [
    'includes'
    'coffee'
    'jasmine'
  ]
