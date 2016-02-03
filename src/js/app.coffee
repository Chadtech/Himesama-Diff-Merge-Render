# Dependencies
_      = require 'lodash'
Render = require './render'

div = ->
  attributes = arguments[0]
  children   = _.toArray arguments

  type:       'div'
  attributes: attributes
  children:   children.slice 1

p = ->
  attributes = arguments[0]
  children   = _.toArray arguments

  type:       'p'
  attributes: attributes
  children:   children.slice 1

justJunk = junk: 'JUNK'

App = 
  div 
    id:         'root'
    yeee:       'dank'
    wow:        'cool'
    div id: 'A',
      div id: 'B',
        div id: 'C',
          p className: 'point', 'Yeee'



Root  = document.getElementById 'root'

dewit = => Render Root, App

setTimeout dewit, 1000

