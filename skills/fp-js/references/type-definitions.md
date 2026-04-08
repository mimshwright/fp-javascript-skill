# Common FP Type Definitions

Shared type definitions for functional TypeScript. Use fp-ts types when available, or define locally for library-agnostic code.

## Function Types

```typescript
/** A function that returns boolean for a given input */
type Predicate<A> = (a: A) => boolean

/** A predicate that also narrows the type (type guard) */
type Refinement<A, B extends A> = (a: A) => a is B

/** A function that transforms A to A (same input/output type) */
type Endomorphism<A> = (a: A) => A

/** A lazy value - deferred computation */
type Lazy<A> = () => A

/** A function with known arity */
type FunctionN<Args extends unknown[], R> = (...args: Args) => R

/** Common function signatures */
type Unary<A, B> = (a: A) => B
type Binary<A, B, C> = (a: A, b: B) => C
type Ternary<A, B, C, D> = (a: A, b: B, c: C) => D

/** Mapper function */
type Mapper<A, B> = (a: A) => B

/** Reducer/fold function */
type Reducer<A, B> = (accumulator: B, current: A) => B

/** Comparator for sorting (-1, 0, 1) */
type Comparator<A> = (a: A, b: A) => -1 | 0 | 1

/** Equivalence check */
type Equivalence<A> = (a: A, b: A) => boolean
```

## Effect Types

```typescript
/** Synchronous computation that may fail */
type IO<A> = () => A

/** Asynchronous computation */
type Task<A> = () => Promise<A>

/** Asynchronous computation that may fail */
type TaskEither<E, A> = () => Promise<Either<E, A>>

/** Computation requiring environment R */
type Reader<R, A> = (r: R) => A

/** Computation with state S */
type State<S, A> = (s: S) => [A, S]
```

## Container Types

```typescript
/** Value that may not exist */
type Option<A> = Some<A> | None
interface Some<A> { readonly _tag: 'Some'; readonly value: A }
interface None { readonly _tag: 'None' }

/** Value that may be an error */
type Either<E, A> = Left<E> | Right<A>
interface Left<E> { readonly _tag: 'Left'; readonly left: E }
interface Right<A> { readonly _tag: 'Right'; readonly right: A }

/** Non-empty array (at least one element) */
type NonEmptyArray<A> = [A, ...A[]]

/** Tuple types */
type Pair<A, B> = readonly [A, B]
type Triple<A, B, C> = readonly [A, B, C]
```

## Algebraic Structure Types

```typescript
/** Semigroup: types that can be combined */
interface Semigroup<A> {
  readonly concat: (x: A, y: A) => A
}

/** Monoid: semigroup with identity element */
interface Monoid<A> extends Semigroup<A> {
  readonly empty: A
}

/** Functor: types that can be mapped over */
interface Functor<F> {
  readonly map: <A, B>(fa: HKT<F, A>, f: (a: A) => B) => HKT<F, B>
}

/** Applicative: functor with of and ap */
interface Applicative<F> extends Functor<F> {
  readonly of: <A>(a: A) => HKT<F, A>
  readonly ap: <A, B>(fab: HKT<F, (a: A) => B>, fa: HKT<F, A>) => HKT<F, B>
}

/** Monad: applicative with chain */
interface Monad<F> extends Applicative<F> {
  readonly chain: <A, B>(fa: HKT<F, A>, f: (a: A) => HKT<F, B>) => HKT<F, B>
}

/** Foldable: types that can be reduced */
interface Foldable<F> {
  readonly reduce: <A, B>(fa: HKT<F, A>, b: B, f: (b: B, a: A) => B) => B
}
```

## Utility Types

```typescript
/** Make all properties mutable */
type Mutable<T> = { -readonly [K in keyof T]: T[K] }

/** Deep readonly */
type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K]
}

/** Extract the value type from a container */
type ValueOf<T> = T extends Option<infer A> ? A
  : T extends Either<any, infer A> ? A
  : T extends Array<infer A> ? A
  : T extends Promise<infer A> ? A
  : never

/** Brand type for nominal typing */
type Brand<T, B> = T & { readonly __brand: B }

/** Newtype wrapper */
type Newtype<URI, A> = { readonly _URI: URI; readonly _A: A }
```

## Common Branded Types

```typescript
/** Positive integer */
type PositiveInt = Brand<number, 'PositiveInt'>

/** Non-empty string */
type NonEmptyString = Brand<string, 'NonEmptyString'>

/** Email address */
type Email = Brand<string, 'Email'>

/** UUID */
type UUID = Brand<string, 'UUID'>

// Smart constructors
const positiveInt = (n: number): Option<PositiveInt> =>
  n > 0 && Number.isInteger(n) ? some(n as PositiveInt) : none

const nonEmptyString = (s: string): Option<NonEmptyString> =>
  s.length > 0 ? some(s as NonEmptyString) : none
```

## fp-ts Imports

When using fp-ts, import from specific modules:

```typescript
import { Predicate, Refinement, Endomorphism } from 'fp-ts/function'
import { Option, Some, None, some, none } from 'fp-ts/Option'
import { Either, Left, Right, left, right } from 'fp-ts/Either'
import { Task } from 'fp-ts/Task'
import { TaskEither } from 'fp-ts/TaskEither'
import { Reader } from 'fp-ts/Reader'
import { State } from 'fp-ts/State'
import { NonEmptyArray } from 'fp-ts/NonEmptyArray'
import { Semigroup } from 'fp-ts/Semigroup'
import { Monoid } from 'fp-ts/Monoid'
```
