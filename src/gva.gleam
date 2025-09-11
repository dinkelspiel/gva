import comparator
import gleam/list
import gleam/string

pub type Class(a) {
  Class(
    default: String,
    resolver: fn(a) -> String,
    defaults: List(a),
    using: List(a),
  )
}

pub fn with(class: Class(a), key: a) -> Class(a) {
  Class(..class, using: [key, ..class.using])
}

pub fn with_all(class: Class(a), keys: List(a)) -> Class(a) {
  case keys {
    [key, ..keys] -> with_all(Class(..class, using: [key, ..class.using]), keys)
    [] -> class
  }
}

pub fn class(class: Class(a), class_string: String) -> Class(a) {
  Class(..class, default: class.default <> " " <> class_string)
}

// Build a list of keys to a class string
fn do_build(
  resolver: fn(a) -> String,
  using: List(a),
  acc: List(String),
) -> String {
  case using {
    [key, ..using] -> do_build(resolver, using, [resolver(key), ..acc])
    [] -> string.join(acc, " ")
  }
}

/// Removes all defaults that are used by the user and keep the ones
/// that should still default to a value.
fn get_relevant_defaults(
  class: Class(a),
  defaults: List(a),
  using: List(a),
  acc: List(a),
) -> List(a) {
  case defaults {
    [default, ..defaults] -> {
      let is_applied =
        list.filter(using, fn(a) { comparator.is_same_kind(a, default) })
        |> list.length
        > 0
      case is_applied {
        True -> get_relevant_defaults(class, defaults, using, acc)
        False -> get_relevant_defaults(class, defaults, using, [default, ..acc])
      }
    }
    [] -> acc
  }
}

/// Build a gva class to a string
pub fn build(class: Class(a)) -> String {
  let remaining_defaults =
    get_relevant_defaults(class, class.defaults, class.using, [])
  let remaining_defaults = do_build(class.resolver, remaining_defaults, [])

  let applied = do_build(class.resolver, class.using, [])

  string.join([class.default, remaining_defaults, applied], " ")
}

/// Helper to create a gva Class type
/// 
/// The default parameter is the string that will be used regardless of any other parameters
/// 
/// The resolver handles which types should go to which classes
/// 
/// 
/// ## Examples
/// 
/// ```gleam
/// type Size {
///   Small
///   Medium
/// }
/// 
/// type Variant {
///   Primary
///   Secondary
/// }
/// 
/// // Define a master Key type for all Variants
/// type Key {
///   Size(Size)
///   Variant(Variant)
/// }
/// 
/// pub fn main() {
///   let button =
///     gva(
///       default: "text-white",
///       // Define a resolver to handle which types should go
///       // to which classes
///       resolver: fn(in: Key) {
///         case in {
///           Size(size) ->
///             case size {
///               Small -> "text-sm"
///               Medium -> "text-md"
///             }
///           Variant(variant) ->
///             case variant {
///               Primary -> "bg-slate-950"
///               Secondary -> "bg-slate-600"
///             }
///         }
///       },
///       // Define which defaults should be applied, if no defaults are
///       // provided and no with() calls are done then the resulting class
///       // will only include the default string which might not be favorable
///       defaults: [Variant(Primary)],
///     )
/// 
///   let class =
///     button
///     |> with(Size(Medium))
///     |> with(Variant(Secondary))
///     |> build()
/// 
///   assert class == "text-white text-md bg-slate-600"
/// 
///   Nil
/// } 
/// ```
pub fn gva(
  default default: String,
  resolver resolver: fn(a) -> String,
  defaults defaults: List(a),
) {
  Class(default, resolver, defaults, [])
}
