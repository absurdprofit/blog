# I Wrote a Brainf*ck JIT Runtime on WASM

The programs we produce have to be executed at some point. How this is done depends on the programming language and its design constraints. I would like to talk about a runtime I wrote for the Brainf*ck programming language.

# What is Brainfuck?
[Brainf*ck](https://en.wikipedia.org/wiki/Brainfuck) is a programming language created by Urban Müller for the expressed purposed of being extremely minimalistic. The execution model of the language maps cleanly to a [Turing machine](https://en.wikipedia.org/wiki/Turing_machine), where data is read from and written to a cell (byte) at a time. The language provides syntax for addressing the next byte to the left or right and even has the notion of input, output and loops!

// The Problem
// Program execution models
// Compiled vs Interpreted (pros/cons)
// Why interpretation is slow

// Constraints
// Fast execution vs compilation overhead

// High-Level Solution
// Using JIT compilation

// Runtime Architecture
// Memory model
// Execution pipeline
// Code generation

// Implementation Details
// Control-flow translation  
// WASM structured control-flow limitations  
// Hopscotch jump technique
// Instruction translation (trait and static dispatch patterns)
// Optimisations
// WASM codegen strategy

// Demo / Benchmarks

// Tradeoffs and Limitations

// Future Work
// Additional optimisations
// WASM func.new proposal
// WAT proc_macro?

// Conclusion