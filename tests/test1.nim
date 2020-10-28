import unittest
import simple_html_gen

test "render":
  var page = Page()
  page.init
    
  var main = Node(tag: "div")
  main.add(Attribute(name: "id", value: "main"))
    
  var title = Node(tag: "h1")
  title.add("Hello, World!")
  main.add(title)

  var notmain = Node(tag: "div")
  notmain.add(Attribute(name: "id", value: "notmain"))

  page.body.add(main)
  page.body.add(notmain)
  page.body.add(Attribute(name: "id", value: "body"))

  echo page.render
