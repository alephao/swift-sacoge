extension Generator {
  public struct Mapping {
    let configuration: Configuration
    let rootAssetDirectory: AssetDirectory

    init(
      configuration: Configuration,
      rootAssetDirectory: AssetDirectory
    ) {
      self.configuration = configuration
      self.rootAssetDirectory = rootAssetDirectory
    }

    public init(
      configuration: Configuration
    ) throws {
      self.configuration = configuration
      self.rootAssetDirectory = try AssetDirectory(configuration: configuration)
    }

    public func generate() -> String {
      let dictEntries = rootAssetDirectory.children.flatMap({
        $0.dictEntries(parentPath: configuration.structName)
      })
      let dictDeclr =
        dictEntries.isEmpty
        ? "public static let externalToInternalMapping: [String: String] = [:]"
        : """
        public static let externalToInternalMapping: [String: String] = [
        \(dictEntries.joined(separator: ",\n").indentLines(2))
        ]
        """

      return """
        extension \(configuration.structName) {
        \(dictDeclr.indentLines(2))
        }
        """
    }
  }
}
