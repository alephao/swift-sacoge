import ArgumentParser

/// Encapsulates `--version` flag behavior.
struct VersionOptions: ParsableArguments {
  @Flag(name: .shortAndLong, help: "Print the version and exit")
  var version: Bool = false

  func validate() throws {
    if version {
      printVersionInformation()
      throw ExitCode.success
    }
  }
}
