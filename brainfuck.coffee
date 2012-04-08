_ = require 'underscore'

exports.cellLimit = 10

exports.evalBrainfuck = (code, getchar, putchar, debug) ->
  codeLength = code.length
  memory = (0 for i in [1..exports.cellLimit])
  p = 0
  whileStack = []
  debugging = _.isFunction debug

  exitLoop= ->
    level = 1
    while level > 0
      i += 1
      open = code.indexOf '[', i
      close = code.indexOf ']', i

      if close is -1
        throw 'Closing ] not found'
      else if open is -1
        i = close
        level -= 1
      else if close < open
        i = close
        level -= 1
      else if open < close
        i = open
        level += 1
      else
        throw 'Closing ] not found'
    i

  for i in [0...codeLength]
    c = code[i]
    switch c
      when '>' then p += 1
      when '<' then p -= 1
      when '+' then memory[p] += 1
      when '-' then memory[p] -= 1
      when '.' then putchar String.fromCharCode memory[p]
      when ',' then memory[p] = getchar().charCodeAt(0)
      when '['
        if memory[p]
          whileStack.push(i)
        else
          exitLoop()
      when ']'
        i = whileStack.pop() - 1 # -1  to cancel the i++ of the for loop
        if _.isNaN(i) then throw 'Opening [ not found'
      else continue
    if debugging
      debug p, memory, c, i, whileStack

