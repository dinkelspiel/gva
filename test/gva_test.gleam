import gleeunit
import gva.{build, gva, with}

pub fn main() -> Nil {
  gleeunit.main()
}

type BasicSize {
  BasicSmall
  BasicMedium
}

type BasicVariant {
  BasicPrimary
  BasicSecondary
}

type BasicKey {
  BasicSize(BasicSize)
  BasicVariant(BasicVariant)
}

pub fn basic_test() -> Nil {
  let button =
    gva(
      "text-white",
      resolver: fn(in: BasicKey) {
        case in {
          BasicSize(size) ->
            case size {
              BasicSmall -> "text-sm"
              BasicMedium -> "text-md"
            }
          BasicVariant(variant) ->
            case variant {
              BasicPrimary -> "bg-slate-950"
              BasicSecondary -> "bg-slate-600"
            }
        }
      },
      defaults: [],
      comparator: fn(a: BasicKey, b: BasicKey) {
        case a, b {
          BasicSize(_), BasicSize(_) -> True
          BasicVariant(_), BasicVariant(_) -> True
          _, _ -> False
        }
      },
    )

  let class =
    button
    |> with(BasicSize(BasicMedium))
    |> with(BasicVariant(BasicSecondary))
    |> build()

  assert class == "text-white text-md bg-slate-600"

  Nil
}

type AdvancedSize {
  AdvancedDefaultSize
  AdvancedSm
  AdvancedLg
  AdvancedIcon
}

type AdvancedVariant {
  AdvancedDefaultVariant
  AdvancedDestructive
  AdvancedOutline
  AdvancedSecondary
  AdvancedGhost
  AdvancedLink
}

type AdvancedKey {
  AdvancedSize(AdvancedSize)
  AdvancedVariant(AdvancedVariant)
}

fn advanced_button() {
  gva(
    "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 shrink-0 [&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
    resolver: fn(in: AdvancedKey) {
      case in {
        AdvancedSize(size) ->
          case size {
            AdvancedDefaultSize -> "h-9 px-4 py-2 has-[>svg]:px-3"
            AdvancedSm -> "h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5"
            AdvancedLg -> "h-10 rounded-md px-6 has-[>svg]:px-4"
            AdvancedIcon -> "size-9"
          }
        AdvancedVariant(variant) ->
          case variant {
            AdvancedDefaultVariant ->
              "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90"
            AdvancedDestructive ->
              "bg-destructive text-white shadow-xs hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 dark:bg-destructive/60"
            AdvancedGhost ->
              "hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50"
            AdvancedLink -> "text-primary underline-offset-4 hover:underline"
            AdvancedOutline ->
              "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50"
            AdvancedSecondary ->
              "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80"
          }
      }
    },
    defaults: [
      AdvancedVariant(AdvancedDefaultVariant),
      AdvancedSize(AdvancedDefaultSize),
    ],
    comparator: fn(a: AdvancedKey, b: AdvancedKey) {
      case a, b {
        AdvancedSize(_), AdvancedSize(_) -> True
        AdvancedVariant(_), AdvancedVariant(_) -> True
        _, _ -> False
      }
    },
  )
}

pub fn advanced_test() -> Nil {
  let class =
    advanced_button()
    |> build()

  assert class
    == "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 shrink-0 [&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive bg-primary text-primary-foreground shadow-xs hover:bg-primary/90 h-9 px-4 py-2 has-[>svg]:px-3"

  Nil
}

pub fn advanced_2_test() -> Nil {
  let class =
    advanced_button()
    |> with(AdvancedVariant(AdvancedSecondary))
    |> build()

  assert class
    == "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 shrink-0 [&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive h-9 px-4 py-2 has-[>svg]:px-3 bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80"

  Nil
}
