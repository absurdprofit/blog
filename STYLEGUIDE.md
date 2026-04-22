## Objective

Produce technical documents that are easy to read at the sentence level while conveying high-density system concepts. Optimize for progressive understanding rather than immediate completeness.

---

## Core Principles

### 1. Lead with a Concrete Mental Model

* Begin with a familiar analogy or real-world system.
* Define the system in plain terms before introducing formal terminology.
* Avoid abstract definitions in the opening section.

**Pattern**

> "At its core, X is a system that does Y..."

**Example (Good)**

> At its core, a ledger is a record of transactions. It stores every change to a balance over time.

**Example (Bad)**

> A ledger is an append-only, strongly consistent, distributed data structure used for transactional integrity.

---

### 2. Use Progressive Disclosure

* Introduce complexity in layers.
* Each section should depend only on prior sections.
* Do not front-load definitions or edge cases.

**Order of Introduction**

1. Problem
2. Constraints
3. High-level solution
4. Components
5. Tradeoffs
6. Implementation details

**Example (Good Flow)**

> The system must handle millions of transactions per second. To support this, it uses indexes to make lookups efficient. These indexes come in different forms depending on consistency needs.

**Example (Bad)**

> The system uses multiple index types including strongly consistent and eventually consistent variants, each with different guarantees, which are implemented using distributed storage primitives.

---

### 3. Structure as Problem → Constraints → Solution

**Example**

**Problem**

> The system must process billions of transactions.

**Constraints**

> Reads must be fast. Writes must remain consistent. Storage costs must stay manageable.

**Solution**

> The system uses multiple index types, each optimized for a different access pattern.

---

### 4. Localise Jargon

* Use technical terms only when necessary.
* Introduce jargon once, with a short functional definition.
* Reuse consistently without redefining.

**Example (Good)**

> An index is a structure that allows fast lookups. Once created, the index is used to retrieve transactions quickly.

**Example (Bad)**

> The system leverages secondary indexing, materialized views, and denormalized query paths for efficient retrieval.

---

### 5. Keep Sentence Complexity Low

* Prefer short sentences (10–20 words).
* Avoid nested clauses.
* Use active voice.

**Example (Good)**

> The system stores transactions in order. It updates indexes after each write.

**Example (Bad)**

> The system, which stores transactions sequentially while simultaneously updating multiple index structures, ensures consistency across distributed nodes.

---

### 6. Separate “What” from “How”

**Example (What)**

> The system stores transactions and allows them to be queried efficiently.

**Example (How)**

> The system uses a distributed log and maintains secondary indexes for query access.

**Bad (Mixed)**

> The system stores transactions and uses a distributed log with secondary indexes to ensure efficient queries.

---

### 7. Use Repeating Explanation Patterns

**Example Pattern Applied**

> A strongly consistent index ensures that reads always reflect the latest write.
> It is used when correctness is critical.
> The tradeoff is higher latency.

---

### 8. Emphasize Tradeoffs Explicitly

**Example (Good)**

> Strong consistency guarantees accuracy. It increases latency and reduces throughput.

**Example (Bad)**

> Strong consistency ensures accurate reads.

---

### 9. Maintain Narrative Flow

**Example (Good)**

> The system must scale to billions of records. To handle this, it introduces indexing. These indexes must balance consistency and performance.

**Example (Bad)**

> The system uses indexes. It also processes transactions. Consistency is important.

---

### 10. Avoid Exhaustive Coverage

**Example (Good)**

> The system supports several index types. The most common are described here.

**Example (Bad)**

> The system supports 17 index variants, including edge cases for rare query patterns and internal optimizations.

---

## Writing Workflow

### Step 1: Define the Core System

**Example**

> This system stores financial transactions and allows them to be queried efficiently.

### Step 2: Identify the Primary Problem

**Example**

> At scale, simple lookups become too slow.

### Step 3: List Constraints

**Example**

> The system must handle millions of writes per second with low latency.

### Step 4: Draft High-Level Architecture

**Example**

> The system stores transactions in a log and builds indexes on top.

### Step 5: Expand Key Components

**Example**

> The log stores all transactions. Indexes allow fast queries. The tradeoff is additional storage.

### Step 6: Add Select Implementation Details

**Example**

> Indexes are updated asynchronously to reduce write latency.

---

## Style Constraints

### Language

* No conversational filler
* No rhetorical questions
* No emotional language

### Formatting

* Use short paragraphs (2–4 sentences)
* Use headings for logical segmentation
* Avoid long bullet lists unless enumerating steps

### Tone

* Neutral and descriptive
* No persuasive framing

---

## Anti-Patterns

### 1. Front-Loaded Abstraction

> Defining multiple abstract concepts before grounding them

### 2. Dense Paragraphs

> Long blocks combining definitions, examples, and tradeoffs

### 3. Undefined Jargon

> Using domain terms without functional explanation

### 4. Mixing Levels of Abstraction

> Switching between architecture and implementation mid-paragraph

### 5. Over-Specification

> Including irrelevant edge cases or internal optimizations

---

## Quality Checklist

Before publishing, verify:

* Can the first section be understood without prior knowledge?
* Does each section depend only on previous ones?
* Is every technical term introduced before use?
* Are tradeoffs explicitly stated?
* Are sentences syntactically simple?
* Is the document readable without diagrams?

---

## Output Characteristics

A document following this style should:

* Be readable linearly without backtracking
* Allow partial understanding at any stopping point
* Convey system intent clearly before implementation details
* Require domain knowledge only for deep understanding, not surface comprehension
