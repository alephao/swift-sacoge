func htmlLayout(_ content: String) -> String {
  """
  <!DOCTYPE html>
  <html>
    <head>
      <title>sacoge example</title>
    </head>
    <body>
      \(content)
    </body>
  </html>
  """
}
