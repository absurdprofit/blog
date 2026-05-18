# Static vs. Dynamic Dispatch
In the world of computer programming, in organisations big and small, it's common to have unknowns. How different programmers have chosen to handle said ambiguity, has been the topic of hot debate for decades. I won't claim to have the answers, I simply would like to discuss my recent experience learning Rust compared to my career writing JavaScript.

## Object Oriented Programming
Many younger programmers, including myself, are being taught today from the angle of Object Oriented Programming. With languages like JavaScript, C# and Java dominating the modern corporate landscape this is understandable. I must admit that learning Object Oriented Programming at the start of my professional career made programming a bit more approachable. After all, it's a more human centric way to model programs. As humans, the majority of us tend to model the world as a collection of objects. The [ancient Greek Theory of Forms](https://en.wikipedia.org/wiki/Theory_of_forms), for example, asserts that reality is fundamentally composed of ideas, or abstract objects.
Object oriented programming, in its purest form, is the art of modelling functionality in a program using "contracts". The various parts of your program would integrate strictly through these devised contracts, which forms part of the core concept of "encapsulation". Concrete implementations could then be provided based on these contracts.

## Dynamic Dispatch
One consequence is that because contracts and their implementations are separated, it leaves figuring out which instructions should come next as a concern for the computer at runtime. [Enter dynamic dispatch](https://en.wikipedia.org/wiki/Dynamic_dispatch), a technique language runtimes use to deduce, the specific implementation of a subroutine (function or method) to execute. Let's look at an example from TypeScript.
```typescript
abstract class Input {
  abstract get stream(): ReadableStream<Uint8Array>;
}

class InputFile extends Input {
  constructor(private handle: File) {
    super();
  }

  get stream(): ReadableStream<Uint8Array> {
    // snip
  }
}

class InputBuffer extends Input {
  constructor(private buffer: ArrayBuffer) {
    super();
  }

  get stream(): ReadableStream<Uint8Array> {
    // snip
  }
}
```
Here we have an Input abstract class (contract) with a simple stream() getter that returns a readable stream of bytes. The concrete implementations each override the stream method to do different things. Their specific implementation isn't really important, just that they return the same thing. Let's look at how we could use this.
```typescript
async function readInput(input: Input) {
  for await (const chunk of input.stream) {
    // snip
  }
}

readInput(new InputBuffer(new ArrayBuffer()));
```
Different languages will resolve something like this very differently. In JavaScript's case, the stream getter is defined on the Input class' prototype. The prototype of a class is an object that provides the blueprint for every instance of that class. When a class uses extends, JavaScript creates a new prototype object for the subclass and links it to the parent class' prototype. For example, the prototype of InputBuffer (not the instance) will be Input in our case. When there is a call to the stream getter, the JavaScript runtime walks the prototype chain (each prototype is linked to its prototype), and the first getter matching the name "stream" will be invoked. In our case since we created an independent implementation of stream for each subclass the stream getter that exists on the prototype of InputBuffer is called.

## Static Dispatch
Static dispatch is another technique used to model unknowns in a program but in a way language toolchains can resolve at compile time. The rest of the code in this article will be in Rust so here's an example of static dispatch in TypeScript for those unfamiliar with Rust.
```typescript
enum OutputKind {
  File,
  Buffer
}
interface Output {
  get kind(): OutputKind;
  write(path: string): void;
}

class OutputFile implements Output {
  constructor(private handle: File) {}

  get kind() {
    return OutputKind.File;
  }

  get write(path: string): void {
    // snip
  }
}

class OutputBuffer implements Output {
  constructor(private buffer: ArrayBuffer) {}

  get kind() {
    return OutputKind.Buffer;
  }

  get write(path: string): void {
    // snip
  }
}

async function write(path: string, output: Output) {
  switch (output.kind) {
    case OutputKind.Buffer:
      output.write(path);
      break;
    case OutputKind.File:
      output.write(path);
      break;
  }
}
```
While learning Rust I tried my hand at creating a very simple stack based virtual machine otherwise known as a "stack machine". A prime example of a stack based VM would be the [Wasmtime WebAssembly runtime](https://github.com/bytecodealliance/wasmtime). At its core is a simple concept, where you have a program composed of high level "instructions" that get executed one at a time, by the runtime, in sequence, where the only state accessible to the program is a stack data structure. It might seem intuitive to reach for dynamic dispatch since we won't know ahead of time exactly which sequence of instructions our runtime might need to execute. I would like to make the case for static dispatch, let's look at the code.
```rust
pub struct Push {
    operand: i32,
}

impl Push {
    pub fn new(operand: i32) -> Self {
        Self { operand }
    }
}

pub struct Add;

pub struct Print;

pub enum InstructionSet {
    Push(Push),
    Add(Add),
    Print(Print),
}

pub trait Instruction {
    fn execute(&self, stack: &mut Vec<i32>) -> ();
}

impl Instruction for Print {
    fn execute(&self, stack: &mut Vec<i32>) -> () {
        // snip
    }
}

impl Instruction for Add {
    fn execute(&self, stack: &mut Vec<i32>) -> () {
        // snip
    }
}

impl Instruction for Push {
    fn execute(&self, stack: &mut Vec<i32>) -> () {
        // snip
    }
}

impl Instruction for InstructionSet {
    fn execute(&self, mut stack: &mut Vec<i32>) -> () {
        match self {
            InstructionSet::Push(push) => push.execute(&mut stack),
            InstructionSet::Add(add) => add.execute(&mut stack),
            InstructionSet::Print(print) => print.execute(&mut stack),
        };
    }
}

fn main() {
    let program: Vec<InstructionSet> = vec![
        InstructionSet::Push(Push::new(50)),
        InstructionSet::Push(Push::new(51)),
        InstructionSet::Add(Add),
        InstructionSet::Print(Print),
    ];
    let mut stack = Vec::new();

    for instruction in program {
        instruction.execute(&mut stack);
    }
}
```
In this snippet I create an object to represent each instruction. Then I add them to an InstructionSet enumeration, this is so I can add instructions of different types to a vector (array-like struct). In the main loop I match on the type of instruction and call the execute function that each object implements. This may seem a bit verbose and may even seem like nothing was gained. On the contrary, for the machine, the difference is night and day. For example, the compiler, when deducing certain optimisations may remove the redundant function call and replace it with the function body itself, a process known as "inlining".
```rust
for instruction in program {
    match instruction {
        InstructionSet::Push(push) => {
            // snip
        }
        InstructionSet::Add(add) => {
            // snip
        }
        InstructionSet::Print(print) => {
            // snip
        }
    };
}
```
I admit, this does look a bit verbose, in practice something like this could become overwhelming when there are dozens or even hundreds of separate variants to consider all across your codebase. In a language like Rust however, there is one saving grace...macros (compile time code generation). I found a neat little crate called [enum_dispatch](https://docs.rs/enum_dispatch/latest/enum_dispatch/) that gives you a quality of life helper annotation you can add to your enums.
```rust
// snip
#[enum_dispatch]
pub trait Instruction {
    fn execute(&self, stack: &mut Vec<i32>) -> ();
}

#[enum_dispatch(Instruction)]
pub enum InstructionSet {
    Push,
    Add,
    Print,
}
// snip
```
The annotations here simply generate the code necessary for static dispatch for us, with the added benefit of generating code that helps us turn our structs into enum variants. The compiler roughly sees:
```rust
// what we had before
impl Instruction for InstructionSet {
    fn execute(&self, mut stack: &mut Vec<i32>) -> () {
        match self {
            InstructionSet::Push(push) => push.execute(&mut stack),
            InstructionSet::Add(add) => add.execute(&mut stack),
            InstructionSet::Print(print) => print.execute(&mut stack),
        };
    }
}

// plus
impl From<Push> for InstructionSet {
    fn from(push: Push) -> Self {
        InstructionSet::Push(push)
    }
}
// ...etc
```
With that our full VM implementation now becomes:
```rust
use enum_dispatch::enum_dispatch;

// snip

#[enum_dispatch]
pub trait Instruction {
    fn execute(&self, stack: &mut Vec<i32>) -> ();
}

#[enum_dispatch(Instruction)]
pub enum InstructionSet {
    Push,
    Add,
    Print,
}

// snip

fn main() {
    let program: Vec<InstructionSet> = vec![
        Push::new(50).into(),
        Push::new(51).into(),
        Add.into(),
        Print.into(),
    ];
    let mut stack = Vec::new();

    for instruction in program {
        instruction.execute(&mut stack);
    }
}
```

---

## Conclusion
Dynamic dispatch and static dispatch solve the same problem in different ways. Both allow programs to work with unknown behaviour through a shared interface. The difference is when the implementation gets resolved.

Dynamic dispatch resolves implementations at runtime. This can make systems more flexible and can reduce boilerplate in application code. The tradeoff is that the runtime must determine which implementation to execute while the program is running.

Static dispatch resolves implementations at compile time. This gives the compiler more opportunities to optimize generated machine code. The tradeoff is that the code can become more explicit and sometimes more verbose.
What I like about crates such as enum_dispatch is that they reduce some of the boilerplate normally associated with static dispatch. The generated code remains explicit to the compiler while keeping the application code relatively small.

On the matter I'd like to leave you with a post I came across recently, I don't take this as anything conclusive, but I do find it an interesting take.
[![OOP was (at least partly) an attempt to create a mechanical system for modeling any area of knowledge with only partial understanding. As a result, its default result is usually extremely defensive and verbose code (see screenshot). Techniques like abstract base classes and inheritance hierarchies are precisely for guarding against future changes caused by ignorance or lack of planning. The problem is this level of generality/flexibility is almost always unnecessary and has non-trivial compile time, run time, and complexity costs.](./references/2054947238036836607.png)](https://x.com/etscrivner/status/2054947238036836607)
As to which solution is best, static dispatch, or dynamic dispatch, the answer is almost always _it depends_.