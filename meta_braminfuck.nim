import macros

let debug {.compileTime.} = true

template log(log_msg: string) =
  if debug:
    echo log_msg

proc braminfuck(b_program: string): NimNode {.compiletime.} =

  var prg_skeleton = @[newStmtList()]
  var data_pointer: int = 0

  template newStatement(text): stmt =
      prg_skeleton[prg_skeleton.high].add(parseStmt(text))

  newStatement "var cells: array[3_000, uint8]"
  newStatement "var cells_pointer: uint = 0"

  while data_pointer < b_program.len:
    let character = b_program[data_pointer]
    case character:
      of '>': newStatement "inc(cells_pointer)"
      of '<': newStatement "dec(cells_pointer)"
      of '+': newStatement "inc(cells[cells_pointer])"
      of '-': newStatement "dec(cells[cells_pointer])"
      of '.': newStatement "stdout.write(chr(cells[cells_pointer]))"
      of ',': newStatement "cells[cells_pointer] = ord(stdin.readChar).uint8"
      of '[': prg_skeleton.add(newStmtList())
      of ']':
        var loop_to_0 = newNimNode(nnkWhileStmt)
        loop_to_0.add(parseStmt("cells[cells_pointer] != 0"))
        loop_to_0.add(prg_skeleton.pop)
        prg_skeleton[prg_skeleton.high].add(loop_to_0)
      else: discard

    data_pointer += 1

  return prg_skeleton[0]

static:
  let prg_skeleton = braminfuck(staticRead("examples/mandelbrot.b.txt"))
  log(prg_skeleton.repr)
