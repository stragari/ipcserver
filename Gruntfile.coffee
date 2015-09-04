'use strict'

module.exports = (grunt) ->

    coffeeLint = require './coffeelint'
    PATTERN_LOAD_TASK =
        pattern: 'grunt-*'
        sope: 'devDependencies'

    (require 'load-grunt-tasks')(grunt, PATTERN_LOAD_TASK)

    appConfig =
        server: 'src'
        build: 'build'

    grunt.initConfig

        config: appConfig

        watch:
            server:
                files: ['<%= config.server %>/**/*.coffee']
                tasks: ['newer:coffee:server']
            config:
                files: ['<%= config.server %>/config/**/*']
                tasks: ['newer:copy:build']

        nodemon:
            dev:
                script: 'build/app.js'
                options:
                    args: []
                    ignore: ['node_modules/**']
                    watch: ['build', 'Gruntfile.coffee']
                    ext: 'js,html'
                    nodeArgs: []
                    env:
                        NODE_ENV: 'development'
                    cwd: __dirname

        copy:
            build:
                files: [
                    expand: true
                    cwd: '<%= config.server %>/config'
                    src: [
                        '!**/*.coffee'
                        '**/*'
                    ]
                    dest: '<%= config.build %>/config'
                ]

        coffee:
            server:
                files:[
                    expand: true
                    cwd: '<%= config.server %>/'
                    src: ['**/*.coffee']
                    dest: '<%= config.build %>/'
                    ext: '.js'
                ]

        clean:
            build:
                options:
                    force: true
                src: ['<%= config.build %>']

        coffeelint:
            app: [
                '<%= config.server %>/**/*.coffee'
            ]
            options: coffeeLint

        concurrent:
            dev:
#                tasks: ['nodemon', 'watch']
                tasks: ['watch']
                options:
                    logConcurrentOutput: true

    grunt.registerTask 'dev', [
        'build'
        'concurrent:dev'
    ]

    grunt.registerTask 'build', [
        'lint'
        'clean:build'
        'coffee'
        'copy:build'
    ]

    grunt.registerTask 'lint', ['coffeelint']