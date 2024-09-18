extension Generator {
  public struct TypeDefinitions {
    let configuration: Configuration

    public init(configuration: Configuration) {
      self.configuration = configuration
    }

    public func generate() -> String {
      """
      public struct \(configuration.structName): Sendable, CustomStringConvertible {
        public let internalPath: String
        public let externalPath: String

        public var description: String { externalPath }

        init(internalPath: String, externalPath: String) {
          self.internalPath = internalPath
          self.externalPath = externalPath
        }
      }
      """
    }
  }
}
