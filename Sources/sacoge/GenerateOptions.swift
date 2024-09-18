import ArgumentParser

struct GenerateOptions: ParsableArguments {
  /// The path to the JSON configuration file that should be loaded.
  ///
  /// If not specified, the default configuration will be used.
  @Option(
    name: .customLong("configuration"),
    help: """
      The path to a JSON file containing the configuration
      """)
  var configuration: String?

  /// The path to a file where the output will be saved.
  ///
  /// If not specified, it will print to stdout.
  @Option(
    name: .customLong("output"),
    help: """
      The path to save the output, if not specified it will print to stdout
      """)
  var output: String?

  func validate() throws {}
}
