fs = require 'fs'
brainfuck = require './brainfuck'
tty = require 'tty'

input = []
output = []

get = () ->
  if input.length > 0
    input.splice(0,1)[0]
  else
    throw 'Out of input'

put = (c) ->
    output.push c

debug = (p, m, c, i, s) ->
  console.log i, c, p, m.join(), s.join()

codeFile = process.argv[2] ? throw 'missing codeFile arg'
inputFile = process.argv[3] ? throw 'missing inputFile arg'
try
  code = fs.readFileSync codeFile, 'ascii'
catch e
  throw 'unable to read file ' + codeFile
try
  inputString = fs.readFileSync inputFile, 'ascii'
catch e
  throw 'unable to read file ' + inputFile
l = inputString.length
for i in [0...l]
  input.push inputString.charAt i

brainfuck.cellLimit = 20
brainfuck.evalBrainfuck(code, get, put, debug)
console.log output.join('')
