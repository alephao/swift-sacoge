import Foundation

struct AssetFile {
  private let url: URL

  /// Where the file is in the file system, relative to the public assets folder
  let internalPath: String

  /// The public path, exposed to the web, to find this file
  let externalPath: String

  init(
    configuration: Configuration,
    url: URL,
    skipChecksum: Bool
  ) throws {
    let internalPath = url.path.replacingOccurrences(
      of: configuration.to,
      with: ""
    )
    let externalPath = url.path.replacingOccurrences(
      of: configuration.to,
      with: configuration.from
    ).replacingOccurrences(of: "//", with: "/")

    if skipChecksum {
      self.url = url
      self.internalPath = internalPath
      self.externalPath = externalPath
      return
    }

    guard let externalURL = URL(string: externalPath) else {
      throw SacogeError(message: "externalURL failed")
    }

    #if swift(>=6)
    let fileURL = URL(filePath: url.path, directoryHint: .notDirectory)
    #else
    let fileURL = URL(fileURLWithPath: url.path)
    #endif

    let data = try Data(contentsOf: fileURL)
    let sum = bytes4(data)

    let externalFileName =
      externalURL.deletingPathExtension().lastPathComponent + "_" + sum + "."
      + externalURL.pathExtension

    #if swift(>=6)
    let externalPathWithChecksum =
      externalURL
      .deletingLastPathComponent()
      .appending(path: externalFileName)
      .path
    #else
    let externalPathWithChecksum =
      externalURL
      .deletingLastPathComponent()
      .appendingPathComponent(externalFileName)
      .path
    #endif

    self.url = url
    self.internalPath = internalPath
    self.externalPath = externalPathWithChecksum
  }
}

extension AssetFile {
  func staticReferenceDeclr() -> String {
    """
    public static let \(staticReferenceVarName) = Asset(
      internalPath: "\(internalPath)",
      externalPath: "\(externalPath)"
    )
    """
  }

  var staticReferenceVarName: String {
    url.lastPathComponent.replacingSymbolsWithUnderscores()
  }

  func dictEntry(parentPath: String) -> String {
    let ref = "\(parentPath).\(staticReferenceVarName)"
    let key = "\(ref).externalPath"
    let value = "\(ref).internalPath"
    return "\(key): \(value)"
  }
}
