import Foundation

struct AssetDirectory {
  let url: URL
  let children: [AssetFileOrDirectory]
  let isBaseDirectory: Bool

  /// Initializes the root public directory
  init(configuration: Configuration) throws {
    var isDir: ObjCBool = false
    let exists = FileManager.default.fileExists(
      atPath: configuration.to,
      isDirectory: &isDir
    )
    guard exists else {
      throw SacogeError(message: "Could not find directory at path '\(configuration.to)'")
    }
    guard isDir.boolValue else {
      throw SacogeError(message: "Expected '\(configuration.to)' to be a directory")
    }
    guard let url = URL(string: configuration.to) else {
      throw SacogeError(message: "Failed to create URL from '\(configuration.to)'")
    }
    let ref = try AssetDirectory(
      configuration: configuration,
      url: url,
      skipChecksum: false
    )
    self.url = ref.url
    self.children = ref.children
    self.isBaseDirectory = true
  }

  init(
    configuration: Configuration,
    url: URL,
    skipChecksum _skipChecksum: Bool
  ) throws {
    let subpaths = try FileManager.default.contentsOfDirectory(atPath: url.path)
      .filter({ !configuration.ignore.contains($0) })
      .sorted()

    var children: [AssetFileOrDirectory] = []

    for subpath in subpaths {
      #if swift(>=6)
      let subpathURL = url.appending(path: subpath)
      #else
      let subpathURL = url.appendingPathComponent(subpath)
      #endif
      var isDir: ObjCBool = false
      _ = FileManager.default.fileExists(
        atPath: subpathURL.path,
        isDirectory: &isDir
      )

      let skipChecksum =
        _skipChecksum || configuration.skipChecksum.contains(where: { $0 == subpath })

      if isDir.boolValue {
        let dir = try AssetDirectory(
          configuration: configuration,
          url: subpathURL,
          skipChecksum: skipChecksum
        )
        children.append(.dir(dir))
        continue
      }

      let file = try AssetFile(
        configuration: configuration,
        url: subpathURL,
        skipChecksum: skipChecksum
      )
      children.append(.file(file))
    }

    self.url = url
    self.children = children
    self.isBaseDirectory = false
  }
}

extension AssetDirectory {
  func declaration() -> String {
    let content = children.map(declaration(for:)).joined(separator: "\n")
    if isBaseDirectory {
      return content
    } else {
      return """
        public enum \(declarationName) {
        \(content.indentLines(2))
        }
        """
    }
  }

  private var declarationName: String {
    url.lastPathComponent.replacingSymbolsWithUnderscores()
  }

  private func declaration(for child: AssetFileOrDirectory) -> String {
    switch child {
    case .file(let assetFile):
      return assetFile.staticReferenceDeclr()
    case .dir(let assetDirectory):
      return assetDirectory.declaration()
    }
  }

  func dictEntries(parentPath: String) -> [String] {
    children.flatMap({ child in
      dictEntries(for: child, parentPath: parentPath)
    })
  }

  func dictEntries(for child: AssetFileOrDirectory, parentPath: String) -> [String] {
    let path = [parentPath, declarationName].joined(separator: ".")
    switch child {
    case .file(let assetFile):
      let entry = assetFile.dictEntry(parentPath: path)
      return [entry]
    case .dir(let assetDirectory):
      return assetDirectory.dictEntries(parentPath: path)
    }
  }
}
