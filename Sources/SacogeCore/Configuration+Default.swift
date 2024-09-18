extension Configuration {
  /// When sacoge reads a configuration file from disk, any values that are not specified in
  /// the JSON will be populated from this default configuration.
  public init() {
    self.from = "/"
    self.to = "./public"
    self.structName = "Asset"
    self.ignore = []
    self.skipChecksum = []
  }
}
