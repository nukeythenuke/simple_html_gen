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

proc render(s: string): seq[string] {.noSideEffect.}=
    if s.contains("\n"): # Split multiline strings and add indentation
      for line in s.splitLines:
        result.add(line)
    else:
      result.add(s)

proc render*(node: Node): seq[string] {.noSideEffect.}=
  var indent = "    "

  var attrs = ""
  for attr in node.attributes:
    attrs.add(" " & attr.name & "=" & attr.value)

  result.add("<" & node.tag & attrs & ">") # Opening tag
  var closingTag = "</" & node.tag & ">"

  if node.value.len == 0: # If node has no value then close on same line
    result[0].add(closingTag)
  elif node.value.len == 1 and node.value[0].ofType(string) and not node.value[0].get(string).contains("\n"): # If only value is a single line string render on 1 line
    result[0].add(node.value[0].get(string))
    result[0].add(closingTag)
  else:
    for val in node.value:
      variantMatch case val as v
      of Node:
        for line in v.render:
          result.add(indent & line)
      of string:
        for line in v.render:
          result.add(indent & line)
      else:
        debugEcho("unknown variant type")
    result.add(closingTag)

proc render*(page: Page): string {.noSideEffect.}=
  result.add("<!DOCTYPE html>\n")
  result.add("<html>\n")

  result.add(page.head.render.join("\n") & "\n")
  result.add(page.body.render.join("\n") & "\n")

  result.add("</html>")