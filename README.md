# braminfuck
Braminfuck, a brainfuck interpreter in Nim.

# How it works?

```nimble build```

You can choose to execute the live program (```braminfuck.nim```) or the
meta-programming version of the brainfuck interpreter
(```braminfuck_call.nim```).

You can compare the both versions of the interpreter.

#### Live

If you want to interpret a 'live' brainfuck program:  
```echo "[->+<]" | ./braminfuck```

If you want to interpret a brainfuck program:  
```./braminfuck myprogram.b.txt```

Few examples are in ```examples``` directory.

#### Meta-programming

The meta-programming program is faster than the live brainfuck interpreter.  
To use it, please to compile the ```braminfuck_call.nim``` program using the
brainfuck file you want to execute.  
After that, you just have to execute ```./braminfuck_call```.

Inspiration, for the meta-prog part, from
[this post](https://howistart.org/posts/nim/1).
