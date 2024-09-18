extension Generator {
  public struct StaticReferences {
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
      """
      extension \(configuration.structName) {
      \(rootAssetDirectory.declaration().indentLines(2))
      }
      """
    }
  }
}
