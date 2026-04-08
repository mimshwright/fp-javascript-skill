# Fantasy Land Specification Reference

Fantasy Land defines algebraic structures for JavaScript. Each algebra is a set of laws that implementations must obey.

## Algebra Hierarchy

```
Setoid ─────────────────────────────────────────────────────────┐
   │                                                             │
   └─▶ Ord                                                       │
                                                                 │
Semigroupoid ──▶ Category                                        │
                                                                 │
Semigroup ──────▶ Monoid                                         │
                                                                 │
Filterable ◀─────────────────────────────────────────────────────┤
                                                                 │
Functor ────┬───▶ Bifunctor                                      │
            │                                                    │
            ├───▶ Profunctor                                     │
            │                                                    │
            ├───▶ Apply ──────▶ Applicative ──┬──▶ Alternative   │
            │        │                        │                  │
            │        └───▶ Chain ─────────────┴──▶ Monad         │
            │                                                    │
            ├───▶ Alt ────────▶ Plus ─────────────▶ Alternative  │
            │                                                    │
            ├───▶ Extend ─────▶ Comonad                          │
            │                                                    │
            └───▶ Traversable ◀──────────────── Foldable ◀───────┘

Contravariant
```

## Core Algebras

### Functor
**Method**: `map :: Functor f => f a ~> (a -> b) -> f b`

**Laws**:
- Identity: `u.map(x => x) === u`
- Composition: `u.map(f).map(g) === u.map(x => g(f(x)))`

**Why it matters**: Lets you transform values inside a container without changing the container's structure.

```typescript
// Array is a Functor
[1, 2, 3].map(x => x * 2) // [2, 4, 6]

// Option/Maybe is a Functor
Some(5).map(x => x * 2)   // Some(10)
None.map(x => x * 2)      // None
```

### Apply
**Method**: `ap :: Apply f => f a ~> f (a -> b) -> f b`

**Laws**:
- Composition: `v.ap(u.ap(a.map(f => g => x => f(g(x))))) === v.ap(u).ap(a)`

**Why it matters**: Lets you apply wrapped functions to wrapped values—enables parallel independent computations.

### Applicative
**Methods**: Apply + `of :: Applicative f => a -> f a`

**Laws**:
- Identity: `v.ap(A.of(x => x)) === v`
- Homomorphism: `A.of(x).ap(A.of(f)) === A.of(f(x))`
- Interchange: `A.of(y).ap(u) === u.ap(A.of(f => f(y)))`

**Why it matters**: `of` lifts a value into the functor context. Combined with `ap`, enables combining multiple independent effects.

### Chain (Monad without of)
**Method**: `chain :: Chain m => m a ~> (a -> m b) -> m b`

**Laws**:
- Associativity: `m.chain(f).chain(g) === m.chain(x => f(x).chain(g))`

**Why it matters**: Enables sequential computations where each step depends on the previous result.

```typescript
// Sequencing async operations
fetchUser(id)
  .chain(user => fetchOrders(user.id))
  .chain(orders => processOrders(orders))
```

### Monad
**Methods**: Applicative + Chain

**Laws**: All Applicative and Chain laws, plus:
- Left identity: `M.of(a).chain(f) === f(a)`
- Right identity: `m.chain(M.of) === m`

**Why it matters**: The most powerful composition pattern—sequences dependent computations with context (errors, async, state, etc.).

### Semigroup
**Method**: `concat :: Semigroup a => a ~> a -> a`

**Laws**:
- Associativity: `a.concat(b).concat(c) === a.concat(b.concat(c))`

**Why it matters**: Defines how to combine two values of the same type.

```typescript
[1, 2].concat([3, 4])     // [1, 2, 3, 4]
"hello".concat(" world")  // "hello world"
Sum(3).concat(Sum(5))     // Sum(8)
```

### Monoid
**Methods**: Semigroup + `empty :: Monoid m => () -> m`

**Laws**:
- Right identity: `m.concat(M.empty()) === m`
- Left identity: `M.empty().concat(m) === m`

**Why it matters**: `empty` provides a default/neutral value, enabling safe folds over empty collections.

### Foldable
**Method**: `reduce :: Foldable f => f a ~> ((b, a) -> b, b) -> b`

**Why it matters**: Collapses a structure into a single value.

### Traversable
**Method**: `traverse :: (Applicative f, Traversable t) => t a ~> (TypeRep f, a -> f b) -> f (t b)`

**Why it matters**: Turns a container of effects inside-out. Essential for "I have a list of maybes, give me a maybe of list."

```typescript
// [Option<A>] -> Option<[A]>
[Some(1), Some(2), Some(3)].sequence(Option) // Some([1, 2, 3])
[Some(1), None, Some(3)].sequence(Option)    // None
```

## Common Data Types & Their Algebras

| Type | Implements |
|------|-----------|
| `Array` | Functor, Apply, Applicative, Chain, Monad, Semigroup, Monoid, Foldable, Traversable, Alt, Plus, Alternative |
| `Option/Maybe` | Functor, Apply, Applicative, Chain, Monad, Alt, Plus, Foldable, Traversable |
| `Either` | Functor, Apply, Applicative, Chain, Monad, Bifunctor, Foldable, Traversable |
| `Task/Future` | Functor, Apply, Applicative, Chain, Monad, Bifunctor |
| `Reader` | Functor, Apply, Applicative, Chain, Monad |
| `State` | Functor, Apply, Applicative, Chain, Monad |

## Resources

- Official spec: https://github.com/fantasyland/fantasy-land
- Static Land (alternative): https://github.com/fantasyland/static-land
- Tom Harding's series: http://www.tomharding.me/fantasy-land/
