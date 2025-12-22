# fp-javascript Skill

A Claude skill for functional programming patterns in JavaScript and TypeScript.

## What is this?

This is a custom skill that teaches Claude best practices for writing functional JavaScript/TypeScript code, including working with libraries like Ramda, fp-ts, Sanctuary, and Effect.

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
