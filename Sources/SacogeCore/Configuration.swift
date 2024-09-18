public struct Configuration: Codable {
  public enum CodingKeys: String, CodingKey {
    case from
    case to
    case structName
    case ignore
    case skipChecksum
  }

  /// Base endpoint path to access the public assets
  ///
  /// - Default: "/"
  public var from: String

  /// Path to the directory containing the public assets
  ///
  /// - Default: "public"
  public var to: String

  /// Name of the struct in the generated code
  ///
  /// - Default: "Asset"
  public var structName: String

  /// List of files and directories to ignore
  ///
  /// - Default: []
  public var ignore: [String]

  /// List of files that should not have the chechsum added to the file name
  ///
  /// - Default: []
  public var skipChecksum: [String]

  public init(
    from: String, to: String, structName: String, ignore: [String], skipChecksum: [String]
  ) {
    self.from = from
    self.to = to
    self.structName = structName
    self.ignore = ignore
    self.skipChecksum = skipChecksum
  }

  public init(from decoder: any Decoder) throws {
    let defaults = Configuration()

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.from = try container.decodeIfPresent(String.self, forKey: .from) ?? defaults.from
    self.to = try container.decodeIfPresent(String.self, forKey: .to) ?? defaults.to
    self.structName =
      try container.decodeIfPresent(String.self, forKey: .structName) ?? defaults.structName
    self.ignore = try container.decodeIfPresent([String].self, forKey: .ignore) ?? defaults.ignore
    self.skipChecksum =
      try container.decodeIfPresent([String].self, forKey: .skipChecksum) ?? defaults.skipChecksum
  }
}
