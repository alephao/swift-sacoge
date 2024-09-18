enum AssetFileOrDirectory {
  case file(AssetFile)
  case dir(AssetDirectory)

  func dictEntries(parentPath: String) -> [String] {
    switch self {
    case .file(let file):
      return [file.dictEntry(parentPath: parentPath)]
    case .dir(let dir):
      return dir.dictEntries(parentPath: parentPath)
    }
  }
}
