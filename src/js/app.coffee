# Dependencies
_      = require 'lodash'
Render = require './render'


A = 
  type:         'div'
  attributes:   (id: 'A')
  children: [(
    type:       'p'
    attributes: (className: 'point')
    children:   ['A']
  )]

B = 
  type:         'div'
  attributes:   (id: 'yeeeeee')
  children: [(
    type:       'p'
    attributes: (className: 'point')
    children:   ['yeeee']
  )]

C = 
  type:         'div'
  attributes:   (id: 'C')
  children: [(
    type:       'p'
    attributes: (className: 'point')
    children:   ['WOW']
  )]

updatedRoot =
  type:         'div'
  attributes:
    id:         'root'
    yeee:       'dank'
    wow:        'cool'
  children:     [ A, B, C ]


Root  = document.getElementById 'root'

dewit = => Render Root, updatedRoot

setTimeout dewit, 1000

