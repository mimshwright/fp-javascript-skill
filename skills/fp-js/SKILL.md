---
name: fp-js
description: Functional programming patterns for JavaScript and TypeScript. Use when writing FP-style code, refactoring imperative code to functional style, working with FP libraries (Ramda, Sanctuary, fp-ts, Effect), implementing algebraic data types, or when the user asks about FP concepts like currying, composition, functors, monads, or Fantasy Land. Also triggers on questions about combinators, type theory in JS/TS, or requests involving pipe/compose patterns.
---

# Functional Programming for JavaScript/TypeScript

Write idiomatic, educational, and maintainable functional code. Always explain _why_ a pattern is used, not just _how_.

## Project Setup

**New projects**: Present library options, ask clarifying questions.
**Existing projects**: Scan `package.json` and adapt to installed libraries.

### Library Comparison (Low → High Purity)

| Library                                 | Purity    | Curve  | Popularity | ADTs | TS        | Link                   |
| --------------------------------------- | --------- | ------ | ---------- | ---- | --------- | ---------------------- |
| Vanilla                                 | Low       | Easy   | N/A        | No   | Native    | —                      |
| [Ramda](https://ramdajs.com)            | Medium    | Easy   | ★★★★★      | No   | Partial   | ramdajs.com            |
| [Sanctuary](https://sanctuary.js.org)   | High      | Medium | ★★☆☆☆      | Yes  | Partial   | sanctuary.js.org       |
| [fp-ts](https://gcanti.github.io/fp-ts) | High      | Hard   | ★★★★☆      | Yes  | Excellent | gcanti.github.io/fp-ts |
| [Effect](https://effect.website)        | High      | Hard   | ★★★☆☆      | Yes  | Excellent | effect.website         |
| [PureScript](https://purescript.org)    | Very High | Hard   | ★★☆☆☆      | Yes  | Own lang  | purescript.org         |

### Decision Shortcuts

- **New to FP?** → Ramda
- **Strict TypeScript?** → fp-ts or Effect
- **Runtime validation?** → Sanctuary
- **Complex async/production?** → Effect
- **Max purity, greenfield?** → PureScript
- **Avoid**: lodash/fp unless explicitly requested

## Code Style Rules

### Core Principles

1. **Curry functions** — Use `R.curry` or equivalent for flexible arity
2. **Pipe over compose** — Left-to-right reads naturally
3. **Never mutate** — Spread operators, no `.push()` or direct assignment
4. **Pure functions** — Same input → same output, no side effects
5. **One library per project** — Don't mix Ramda with fp-ts; pick one and stick with it

### Extraction Heuristic

Extract into named functions when:

- Used more than once, OR
- Hard to parse at a glance (e.g., nested pipes, multiple composed operations)

Inline simple one-operation expressions like `R.prop('email')` or `R.propEq('active', true)`.

### Type Signatures in Comments

Include Haskell-style signatures for reusable functions (don't repeat the function name):

```typescript
// :: Functor f => f a ~> (a -> b) -> f b
const map = R.curry(<A, B>(f: (a: A) => B, fa: A[]) => fa.map(f));

// :: (a -> Boolean) -> [a] -> [a]
const filter = R.curry(<A>(pred: Predicate<A>, xs: A[]) => xs.filter(pred));
```

Notation: `::` = has type, `=>` = constraint, `~>` = method, `->` = function

### TypeScript

- Only add explicit types when not inferable
- Use fp-ts types (`Predicate`, `Endomorphism`) when available, define locally otherwise

### Ramda-Specific

- Avoid `R.__` placeholder (typing issues)
- Use standalone functions: `R.map(fn, arr)` not `arr.map(fn)`
- Data-last style consistently

## Behavioral Guidelines

### DRY Extraction

Extract repeated patterns into reusable functions. Don't over-extract one-off expressions.

### Educational Narration

Explain non-obvious choices when asked or when introducing unfamiliar patterns. Don't justify the library choice once it's been made.

### Testing

- **Test atomic functions** (predicates, transformers, validators)
- **Skip/minimize composed pipelines** — correctness by construction
- Coverage for insight, not metrics

## References (load when needed)

- `references/fantasy-land.md` — Algebra hierarchy and laws
- `references/combinators.md` — Bird combinators (K, S, I, B, C)
- `references/type-definitions.md` — Common FP type signatures
- `references/type-theory.md` — ADTs, sum/product types, HKT

## External Resources

- [Fantas, Eel, and Specification](http://www.tomharding.me/fantasy-land/) — Fantasy Land tutorial series
- [fp-ts docs](https://gcanti.github.io/fp-ts/) — TypeScript FP patterns
- [Ramda docs](https://ramdajs.com/docs/) — Utility function reference
