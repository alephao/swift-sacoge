extension String {
  func replacingSymbolsWithUnderscores() -> String {
    replacingOccurrences(of: " ", with: "_")
      .replacingOccurrences(of: "-", with: "_")
      .replacingOccurrences(of: "@", with: "_")
      .replacingOccurrences(of: ".", with: "_")
  }

  func indent(_ n: Int) -> String {
    return String(repeating: " ", count: n) + self
  }

  func indentLines(_ n: Int) -> String {
    let spaces = String(repeating: " ", count: n)
    return spaces + replacingOccurrences(of: "\n", with: "\n\(spaces)")
  }
}
