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
              src: ['src/start.pegjs','src/adoration.pegjs','src/requests.pegjs','packages/esonatlangtools/expressions.pegjs','packages/esonatlangtools/literals.pegjs','packages/esonatlangtools/whitespace.pegjs'],
              dest: 'olympus.pegjs',
              nonull: true,
          },
      }
        
    });

    grunt.loadNpmTasks('grunt-contrib-concat');
  };