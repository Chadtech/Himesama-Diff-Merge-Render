# Dependencies
_      = require 'lodash'
Render = require './render'


A = 
  type:         'div'
  attributes:   (id: 'A')
  children: [(
    type:       'p'
    attributes: ('class': 'point')
    children:   ['A']
  )]

B = 
  type:         'div'
  attributes:   (id: 'B')
  children: [(
    type:       'p'
    attributes: ('class': 'point')
    children:   ['B']
  )]

C = 
  type:         'div'
  attributes:   (id: 'C')
  children: [(
    type:       'p'
    attributes: ('class': 'point')
    children:   ['C']
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

