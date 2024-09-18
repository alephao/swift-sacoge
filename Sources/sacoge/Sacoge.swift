import ArgumentParser

@main struct SacogeCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "sacoge",
    abstract: "Static Assets Codegen",
    subcommands: [
      DumpConfiguration.self,
      Generate.self,
    ]
  )

  @OptionGroup()
  var versionOptions: VersionOptions
}
