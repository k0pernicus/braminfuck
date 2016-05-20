let doc = """
Braminfuck, a brainfuck interpreter in Nim.

Usage:
  braminfuck
  braminfuck <filename>
  braminfuck (-h | --help)
  braminfuck --version

Options:
  -h --help     Show this screen.
  --version     Show version.
"""

import docopt
import os

let program_arguments = docopt(doc, version="0.1.0")

proc print_char(value: uint8): char =
  chr(value)

proc put_char(): uint8 =
  ord(stdin.readChar).uint8

# Initialize cells, data_pointer
# The cells field is a field to store program instructions
# The cells_pointer is a field to remember our position in the cells field
# The data_pointer is just a pointer to the current instruction
var
  cells : seq[uint8]

proc run(code: string) =

  var
    cells_pointer : int32 = 0
    data_pointer : int32 = 0
    # for '[' and ']' cases
    casual_statement: seq[int32] = newSeq[int32]()

  cells = newSeq[uint8]()

  while data_pointer <= code.len:

    if cells_pointer == cells.len:
      cells.add(0)

    #echo "=> ", code[data_pointer]

    case code[data_pointer]:
      of '>': inc(cells_pointer)
      of '<': dec(cells_pointer)
      of '+': inc(cells[cells_pointer])
      of '-': dec(cells[cells_pointer])
      of '.': stdout.write(print_char(cells[cells_pointer]))
      of ',': cells[cells_pointer] = put_char()
      of '[':
        if cells[cells_pointer] == 0:
          var open_brackets = 0
          inc(data_pointer)
          while code[data_pointer] == ']' or open_brackets > 0:
            if code[data_pointer] == '[': inc(open_brackets)
            if code[data_pointer] == ']' and open_brackets > 0:
              dec(open_brackets)
            inc(data_pointer)
        else:
          casual_statement.add(data_pointer)
      of ']':
        if casual_statement.len != 0:
          data_pointer = casual_statement.pop()
          continue
      else: discard

    inc(data_pointer)

# Get the brainfuck file if exists, else read entries
let code: string =
  if program_arguments["<filename>"]: readFile($program_arguments["<filename>"])
  else: readAll(stdin)

run(code)
