import variant
import strutils

type
  Attribute* = ref object
    name*: string
    value*: string
  Node* = ref object
    tag*: string
    attributes: seq[Attribute]
    value: Variant
  Page* = ref object
    head*: Node
    body*: Node

proc init*(page: Page) =
  page.head = Node(tag: "head")
  page.body = Node(tag: "body")

proc add*(node: Node, attr: Attribute) =
  node.attributes.add(attr)

proc add*(node: Node, value: Node) =
  if not node.value.ofType(seq[Node]):
    node.value = newVariant(@[value])
  else:
    var res = node.value.get(seq[Node])
    res.add(value)
    node.value = newVariant(res)

proc add*(node: Node, value: string) =
  if not node.value.ofType(string):
    node.value = newVariant(value)
  else:
    var res = node.value.get(string)
    res.add(value)
    node.value = newVariant(res)

proc render*(node: Node, depth: int = 0): string =
  var indent = strutils.repeat('\t', depth)

  result.add("\n" & indent & "<" & node.tag)
  for attr in node.attributes:
    result.add(" " & attr.name & "=" & attr.value)
  result.add(">")

  variantMatch case node.value as value
  of seq[Node]:
    for child in value:
      result.add(child.render(depth + 1))
  of string:
    result.add(value)
  else:
    if not node.value.isEmpty():
      echo "unknown variant type in " & node.tag

  if(result.endsWith('>') and not result.endsWith(node.tag & '>')):
    result.add('\n' & indent)
  result.add("</" & node.tag & ">")

proc render*(page: Page): string =
  result.add("<!DOCTYPE html>\n")
  result.add("<html>")

  result.add(render(page.head))
  result.add(render(page.body))

  result.add("\n</html>")