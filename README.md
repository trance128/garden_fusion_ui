# Garden Fusion UI

What do you get when you combine Petal Components and Salad UI?  Garden Fusion.

## Why does this exist?

Garden Fusion sprouted from a desire to cultivate a more flexible and reliable component library for Phoenix LiveView. Here's why we planted these seeds:
1. *Tailwind Inline Bliss*: Petal Components, while lovely, uses a class-based approach like this:
```
class={[
  "pc-icon-button",
  @disabled && "pc-button--disabled",
  "pc-icon-button-bg--#{@color}",
  "pc-icon-button--#{@color}",
  "pc-icon-button--#{@size}",
  @class
]}
```
This makes tweaking styles about as fun as untangling garden hoses. Garden Fusion opts for inline Tailwind classes, allowing you to prune and shape your components with ease.


2. *No More Wilting Forms*: Salad UI, while nutritious, had some components that were less than reliable. Inputs didn't always play nice with forms, leaving developers with a bad taste. Garden Fusion ensures all components are fresh and function as expected.

3.  *Installer*: We've included a magical installer that's so nice, it's practically a miracle.  Components are installed directly into your project structure, so you can modify and customize with ease


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `garden_fusion` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:garden_fusion, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/garden_fusion>.

