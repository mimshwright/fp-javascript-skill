# Combinators Reference

Combinators are functions that operate only on their inputs with no external dependencies. Named after birds by Raymond Smullyan in "To Mock a Mockingbird."

## Essential Combinators

| Bird | Letter | Lambda | JS Implementation | Common Name |
|------|--------|--------|-------------------|-------------|
| **Idiot** | I | λa.a | `a => a` | `identity` |
| **Kestrel** | K | λab.a | `a => b => a` | `constant` |
| **Kite** | KI | λab.b | `a => b => b` | `constant(identity)` |
| **Cardinal** | C | λfab.fba | `f => a => b => f(b)(a)` | `flip` |
| **Bluebird** | B | λfga.f(ga) | `f => g => a => f(g(a))` | `compose` |
| **Thrush** | T | λaf.fa | `a => f => f(a)` | `applyTo` / `pipe(1)` |
| **Vireo** | V | λabf.fab | `a => b => f => f(a)(b)` | `pair` |
| **Starling** | S | λfga.fa(ga) | `f => g => a => f(a)(g(a))` | `ap` / `substitution` |
| **Mockingbird** | M | λf.ff | `f => f(f)` | `self-apply` |
| **Warbler** | W | λfa.faa | `f => a => f(a)(a)` | `duplicate` |
| **Phoenix** | Φ | λfgab.f(ga)(gb) | `f => g => a => b => f(g(a))(g(b))` | `liftA2` / `on` |
| **Blackbird** | B1 | λfgab.f(gab) | `f => g => a => b => f(g(a)(b))` | `compose2` |
| **Queer** | Q | λfga.g(fa) | `f => g => a => g(f(a))` | `pipe` / `sequence` |
| **Eagle** | E | λfgab.f(ga)(gb) | same as Phoenix | `liftA2` |

## Practical Applications

### Identity (I)
```typescript
const I = <A>(a: A): A => a

// Use: default function, placeholder, unwrapping
arr.filter(I)              // filter truthy
option.getOrElse(I)        // unwrap with identity
```

### Constant (K)
```typescript
const K = <A>(a: A) => <B>(_b: B): A => a

// Use: ignore arguments, create constant functions
arr.map(K(0))              // [0, 0, 0, ...]
promise.catch(K(defaultValue))
```

### Flip (C)
```typescript
const C = <A, B, C>(f: (a: A) => (b: B) => C) => 
  (b: B) => (a: A): C => f(a)(b)

// Use: swap argument order for point-free style
const contains = C(includes)  // contains(arr)(item) instead of includes(item)(arr)
```

### Compose (B)
```typescript
const B = <B, C>(f: (b: B) => C) => 
  <A>(g: (a: A) => B) => 
    (a: A): C => f(g(a))

// Use: right-to-left composition
const loudLength = B(toUpper)(length)  // toUpper(length(x))
```

### Thrush / Apply-To (T)
```typescript
const T = <A>(a: A) => <B>(f: (a: A) => B): B => f(a)

// Use: pipeline, left-to-right application
const result = T(5)(add(3))  // add(3)(5) = 8
```

### Substitution (S)
```typescript
const S = <A, B, C>(f: (a: A) => (b: B) => C) => 
  (g: (a: A) => B) => 
    (a: A): C => f(a)(g(a))

// Use: apply two functions to same argument
const greet = S(name => greeting => `${greeting}, ${name}!`)(getTitle)
// greet("Alice") where getTitle("Alice") = "Dr." → "Dr., Alice!"
```

### Pair / Vireo (V)
```typescript
const V = <A>(a: A) => <B>(b: B) => 
  <C>(f: (a: A) => (b: B) => C): C => f(a)(b)

// Use: create pairs, Church encoding of tuples
const pair = V(1)(2)
const fst = pair(K)   // 1
const snd = pair(KI)  // 2
```

## Combinator Relationships

```
I = SKK           -- Identity from S and K
KI = K(I) = CK    -- Kite is flipped Kestrel
B = S(KS)K        -- Compose from S and K  
C = S(S(K(S(KS)K))S)(KK)  -- Flip from S and K
T = CI            -- Thrush is flipped Identity
W = SS(KI)        -- Warbler from S and K
```

The S and K combinators alone can express any computation (SKI calculus is Turing complete).

## In Ramda

| Combinator | Ramda |
|------------|-------|
| I | `R.identity` |
| K | `R.always` |
| C | `R.flip` |
| B | `R.compose` / `R.o` |
| T | `R.applyTo` |
| S | `R.ap` (for functions) |
| W | `R.unnest` (specialized) |

## Resources

- https://gist.github.com/Avaq/1f0636ec5c8d6aed2e45 — Comprehensive JS combinator table
- "To Mock a Mockingbird" by Raymond Smullyan
- https://www.willtaylor.blog/combinators-and-church-encoding-in-javscript/
