import unittest
import simple_html_gen

test "render":
  var page = Page()
  page.init
    
  var main = Node(tag: "div")
  main.add(Attribute(name: "id", value: "main"))
    
  var title = Node(tag: "h1")
  title.add(Attribute(name: "id", value: "title"))
  title.add("Hello, World!")
  main.add(title)

  var title2 = Node(tag: "h1")
  title2.add("Hello,\nWorld")
  main.add(title2)

  var notmain = Node(tag: "div")
  notmain.add(Attribute(name: "id", value: "notmain"))

  page.body.add(main)
  page.body.add(notmain)
  page.body.add(Attribute(name: "id", value: "body"))
  page.body.add("I am just text")
  page.body.add("I am a multi-\nline string")

  echo page.render
