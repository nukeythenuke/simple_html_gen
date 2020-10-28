import variant
import strutils

type
  Attribute* = ref object
    name*: string
    value*: string
  Node* = ref object
    tag*: string
    attributes: seq[Attribute]
    value: seq[Variant]
  Page* = ref object
    head*: Node
    body*: Node

proc init*(page: Page) =
  page.head = Node(tag: "head")
  page.body = Node(tag: "body")

proc add*(node: Node, attr: Attribute) =
  node.attributes.add(attr)

proc add*(node: Node, value: Node) =
  node.value.add(newVariant(value))

proc add*(node: Node, value: string) =
  node.value.add(newVariant(value))

proc render*(node: Node, crumb: var seq[string]): string =
  var indent = strutils.repeat('\t', crumb.len)
  crumb.add(node.tag)

  result.add("\n" & indent & "<" & node.tag)
  for attr in node.attributes:
    result.add(" " & attr.name & "=" & attr.value)
  result.add(">")

  for val in node.value:
    variantMatch case val as v
    of Node:
      result.add(v.render(crumb))
    of string:
      result.add(v)
    else:
      echo "unknown variant type in " & crumb.join("->")

  if(result.endsWith('>') and not result.endsWith(node.tag & '>')):
    result.add('\n' & indent)
  result.add("</" & node.tag & ">")

  discard crumb.pop

proc render*(page: Page): string =
  result.add("<!DOCTYPE html>\n")
  result.add("<html>")

  var crumb: seq[string]
  result.add(render(page.head, crumb))
  result.add(render(page.body, crumb))

  result.add("\n</html>")