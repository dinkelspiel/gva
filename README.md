# gva

Type-safe, composable class variants for Gleam

[![Package Version](https://img.shields.io/hexpm/v/gva)](https://hex.pm/packages/gva)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gva/)

## Usage

```sh
gleam add gva@1
```

```gleam
type Size {
  Small
  Medium
}

type Variant {
  Primary
  Secondary
}

// Define a master Key type for all Variants
type Key {
  Size(Size)
  Variant(Variant)
}

pub fn main() {
  let button =
    gva(
      default: "text-white",
      // Define a resolver to handle which types should go
      // to which classes
      resolver: fn(in: Key) {
        case in {
          Size(size) ->
            case size {
              Small -> "text-sm"
              Medium -> "text-md"
            }
          Variant(variant) ->
            case variant {
              Primary -> "bg-slate-950"
              Secondary -> "bg-slate-600"
            }
        }
      },
      // Define which defaults should be applied, if no defaults are
      // provided and no with() calls are done then the resulting class
      // will only include the default string which might not be favorable
      defaults: [Variant(Primary)],
      // Create a comparator to see when two top level keys are matching
      comparator: fn(a: Key, b: Key) {
        case a, b {
          Size(_), Size(_) -> True
          Variant(_), Variant(_) -> True
          _, _ -> False
        }
      },
    )

  let class =
    button
    |> with(Size(Medium))
    |> with(Variant(Secondary))
    |> build()

  assert class == "text-white text-md bg-slate-600"

  Nil
}
```

Further documentation can be found at <https://hexdocs.pm/gva>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
