module.exports = function(grunt) {
    grunt.initConfig({
      gruntfile: {
          src: 'Gruntfile.js'
      },
      concat: {
          options: {
              separator: '\n',
          },
          dist: {
              src: ['src/start.pegjs','src/adoration.pegjs','src/requests.pegjs','src/expressions.pegjs','src/literals.pegjs','src/whitespace.pegjs'],
              dest: 'olympus.pegjs',
              nonull: true,
          },
      }
        
    });

    grunt.loadNpmTasks('grunt-contrib-concat');
  };