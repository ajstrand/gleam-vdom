//// Contains the pure virtual DOM representation `Node` and functions for
//// interacting with it.

import gleam/map.{Map}
import gleam/string
import gleam/list

pub type Node {
  Element(tag: String, attributes: Map(String, String), children: List(Node))
  Text(value: String)
}

/// Render a `Node` to its HTML representation.
pub fn render(node: Node) {
  case node {
    Element(tag: tag, attributes: attributes, children: children) -> {
      let rendered_body =
        children
        |> list.map(with: render)
        |> list.fold(from: "", with: string.append)
      let rendered_attributes =
        attributes
        |> map.fold(
          from: "",
          with: fn(acc, key, value) {
            let rvalue =
              "\""
              |> string.append(value)
              |> string.append("\"")
            let pair =
              key
              |> string.append("=")
              |> string.append(rvalue)
            string.append(acc, string.append(" ", pair))
          },
        )
      string.append("<", tag)
      |> string.append(rendered_attributes)
      |> string.append(">")
      |> string.append(rendered_body)
      |> string.append("</")
      |> string.append(tag)
      |> string.append(">")
    }

    Text(value: value) -> value
  }
}

/// Helper function for creating a virtual DOM element.
pub fn element(
  tag: String,
  attributes: List(#(String, String)),
  children: List(Node),
) -> Node {
  Element(tag: tag, attributes: map.from_list(attributes), children: children)
}

/// Same as `element` without children.
pub fn element_(tag: String, attributes: List(#(String, String))) -> Node {
  Element(tag: tag, attributes: map.from_list(attributes), children: [])
}

/// Helper function for creating a virtual text element.
pub fn text(value: String) -> Node {
  Text(value: value)
}
