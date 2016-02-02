# Dependencies
_ = require 'lodash'

isUpperCase = (l) -> l isnt l.toLowerCase()

module.exports = Utilities = 

  deCamelCase: (string) ->
    _.reduce (string.split ''), (sum, char) ->
      smallChar = char.toLowerCase()
      char = '-' + smallChar if isUpperCase char
      sum + char

  delimit: (key, value) ->
    key + ': ' + value + '; '


