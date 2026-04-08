# Type Theory for Functional JavaScript

Core type theory concepts as they apply to JavaScript and TypeScript.

## Algebraic Data Types (ADTs)

ADTs are types formed by combining other types. "Algebraic" because we can reason about them using algebra.

### Product Types ("AND")

A product type contains values from multiple types simultaneously.

```typescript
// Tuple: ordered product
type Point = [number, number]  // number AND number

// Record/Object: labeled product  
interface User {
  name: string    // string AND
  age: number     // number AND
  active: boolean // boolean
}
```

**Cardinality**: The number of possible values is the *product* of component cardinalities.

```typescript
type Bool = true | false                    // 2 values
type Pair = [Bool, Bool]                    // 2 × 2 = 4 values
// Possible: [true, true], [true, false], [false, true], [false, false]

type Hour = 1|2|3|4|5|6|7|8|9|10|11|12     // 12 values
type Period = 'AM' | 'PM'                   // 2 values
type ClockTime = [Hour, Period]             // 12 × 2 = 24 values
```

### Sum Types ("OR")

A sum type holds a value from exactly one of several types.

```typescript
// Union: discriminated by value
type StringOrNumber = string | number

// Tagged union: discriminated by tag
type Result<E, A> = 
  | { _tag: 'Failure'; error: E }
  | { _tag: 'Success'; value: A }
```

**Cardinality**: The number of possible values is the *sum* of component cardinalities.

```typescript
type Bool = true | false                    // 2 values
type Maybe<Bool> = None | Some<Bool>        // 1 + 2 = 3 values
// Possible: None, Some(true), Some(false)
```

### Why Cardinality Matters

Smaller cardinality = fewer states to test = fewer bugs.

```typescript
// BAD: 2 × 2 = 4 states, but only 3 are valid
interface TextInput {
  editable: boolean
  onChange?: (text: string) => void  // Only meaningful if editable
}
// Invalid state: { editable: false, onChange: someFn }

// GOOD: 2 states, both valid
type TextInput = 
  | { _tag: 'ReadOnly' }
  | { _tag: 'Editable'; onChange: (text: string) => void }
```

**Principle**: Make illegal states unrepresentable.

## Pattern Matching

Exhaustively handling all cases of a sum type.

```typescript
type Shape = 
  | { _tag: 'Circle'; radius: number }
  | { _tag: 'Rectangle'; width: number; height: number }

// TypeScript's switch provides exhaustiveness checking
const area = (shape: Shape): number => {
  switch (shape._tag) {
    case 'Circle': 
      return Math.PI * shape.radius ** 2
    case 'Rectangle': 
      return shape.width * shape.height
    // If we miss a case, TypeScript errors
  }
}

// Using a fold/match function (more FP style)
const match = <A>(
  onCircle: (radius: number) => A,
  onRectangle: (width: number, height: number) => A
) => (shape: Shape): A => {
  switch (shape._tag) {
    case 'Circle': return onCircle(shape.radius)
    case 'Rectangle': return onRectangle(shape.width, shape.height)
  }
}
```

## Higher-Kinded Types (HKTs)

Types that take other type constructors as parameters.

### The Problem

We want to write generic code over any "container":

```typescript
// This doesn't work - F is not a type constructor
interface Functor<F> {
  map: <A, B>(fa: F<A>, f: (a: A) => B) => F<B>  // Error!
}
```

TypeScript doesn't support this directly.

### The Solution: Defunctionalization

fp-ts uses a type-level dictionary to simulate HKTs:

```typescript
// 1. Define a URI for your type
const URI = 'Option'
type URI = typeof URI

// 2. Register it in the global type map
declare module 'fp-ts/HKT' {
  interface URItoKind<A> {
    readonly Option: Option<A>
  }
}

// 3. Use Kind<URI, A> to get Option<A>
import { Kind, URIS } from 'fp-ts/HKT'

interface Functor<F extends URIS> {
  readonly map: <A, B>(fa: Kind<F, A>, f: (a: A) => B) => Kind<F, B>
}
```

### Why HKTs Matter

They enable writing code that works with any Functor, Monad, etc.:

```typescript
// Works with Option, Either, Array, Task, etc.
const doubleInside = <F extends URIS>(F: Functor<F>) =>
  (fa: Kind<F, number>): Kind<F, number> =>
    F.map(fa, x => x * 2)
```

## Variance

How subtyping relationships transfer through type constructors.

### Covariance (output position)
If `Dog extends Animal`, then `Array<Dog> extends Array<Animal>`.

```typescript
type Producer<A> = () => A  // Covariant in A
```

### Contravariance (input position)
If `Dog extends Animal`, then `Consumer<Animal> extends Consumer<Dog>`.

```typescript
type Consumer<A> = (a: A) => void  // Contravariant in A
```

### Invariance (both positions)
Neither direction works.

```typescript
type Endo<A> = (a: A) => A  // Invariant in A
```

### In TypeScript

```typescript
// Covariant: readonly properties, return types
interface Box<out A> { readonly value: A }

// Contravariant: function parameters
interface Handler<in A> { handle(a: A): void }

// Invariant: mutable properties
interface Ref<A> { value: A }
```

## Common Type Isomorphisms

Two types are isomorphic if you can convert between them without losing information.

```typescript
// A × 1 ≅ A
type WithUnit<A> = [A, void]  // isomorphic to A

// A + 0 ≅ A  
type WithNever<A> = A | never  // isomorphic to A

// A × 0 ≅ 0
type WithAbsurd<A> = [A, never]  // isomorphic to never

// A → B ≅ B^A
type Fn<A, B> = (a: A) => B  // "exponential type"

// (A, B) → C ≅ A → B → C
// Currying isomorphism
```

## Resources

- Giulio Canti's ADT talk: https://github.com/gcanti/talks/blob/master/talks/adt/adt.md
- "What Are Sum, Product, and Pi Types?": https://manishearth.github.io/blog/2017/03/04/what-are-sum-product-and-pi-types/
- fp-ts HKT explanation: https://ybogomolov.me/01-higher-kinded-types
- James Sinclair on ADTs: https://jrsinclair.com/articles/2019/algebraic-data-types-what-i-wish-someone-had-explained-about-functional-programming/
