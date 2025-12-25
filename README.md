# fp-javascript Skill

A Claude skill for functional programming patterns in JavaScript and TypeScript.

## What is this?

This is a custom skill that teaches Claude to write idiomatic, educational, and maintainable functional code in JavaScript and TypeScript. The skill provides comprehensive guidance on:

- **Functional Programming Principles**: Purity, immutability, composition, currying, and piping
- **Library Selection**: Detailed comparison and recommendations for Ramda, fp-ts, Sanctuary, Effect, and PureScript
- **Code Style Standards**: Data-last composition, Haskell-style type signatures, and when to extract vs inline functions
- **TypeScript Integration**: FP-specific type patterns, generic constraints, and type inference strategies
- **Testing Strategies**: Focused testing of atomic functions with "correctness by construction" for composed pipelines
- **Algebraic Structures**: Fantasy Land specifications, functors, monads, and algebraic data types
- **Advanced Topics**: Combinators (K, S, I, B, C), type theory, higher-kinded types, and sum/product types

The skill adapts to your project by detecting installed libraries in `package.json` and provides context-aware recommendations based on your purity requirements, TypeScript usage, and team experience level.

## Installation

1. Clone this repository
2. Build the skill file:
   ```bash
   npm run build
   ```
3. The distributable `.skill` file will be created in `dist/fp-javascript.skill`
4. Add the skill to your Claude configuration

## Development

### Project Structure

```
fp-javascript-skill/
├── src/
│   ├── SKILL.md              # Main skill instructions
│   └── references/           # Reference documentation
│       ├── combinators.md
│       ├── fantasy-land.md
│       ├── type-definitions.md
│       └── type-theory.md
├── dist/                     # Build output (gitignored)
│   └── fp-javascript.skill
├── build.sh                  # Build script
├── package.json              # Project metadata and scripts
└── README.md                 # This file
```

### Building

The skill file is a zip archive containing the markdown source files. To build:

```bash
npm run build
```

Or directly:

```bash
./build.sh
```

### Editing

Edit the markdown files in `src/` directory:
- [src/SKILL.md](src/SKILL.md) - Main skill content
- [src/references/](src/references/) - Additional reference materials

After making changes, rebuild the skill file.

## What does this skill cover?

- Functional programming principles (purity, immutability, composition)
- Library selection guidance (Ramda, fp-ts, Sanctuary, Effect, PureScript)
- Code style rules (currying, piping, type signatures)
- TypeScript patterns for FP
- Testing strategies for functional code
- Fantasy Land specifications and algebraic structures
- Combinators and type theory

## License

MIT
