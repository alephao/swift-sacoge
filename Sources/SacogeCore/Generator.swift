public struct Generator {
  let configuration: Configuration
  let rootAssetDirectory: AssetDirectory

  public init(configuration: Configuration) throws {
    self.configuration = configuration
    self.rootAssetDirectory = try AssetDirectory(configuration: configuration)
  }

  public func generate() -> String {
    let typeDefinitions = TypeDefinitions(configuration: configuration).generate()
    let staticReferences = StaticReferences(
      configuration: configuration, rootAssetDirectory: rootAssetDirectory
    ).generate()
    let mapping = Mapping(configuration: configuration, rootAssetDirectory: rootAssetDirectory)
      .generate()

    return """
      \(typeDefinitions)

      \(staticReferences)

      \(mapping)
      """
  }
}
