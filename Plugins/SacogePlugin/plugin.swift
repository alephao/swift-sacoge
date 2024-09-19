import PackagePlugin
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@main
struct SacogePlugin: BuildToolPlugin {
  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
    guard target is SwiftSourceModuleTarget else { return [] }

    // Prepare sacoge to run
    // Get `sacoge` executable
    let sacoge = try context.tool(named: "sacoge")

    let inputFiles: [Path] = []
    var outputFiles: [Path] = []

    // TODO: Find inputFiles
    // Get input config file
    // if let configPath = context.package.directory.appending(".sacoge") {
    //  inputFiles.append(configPath)
    // }
    // TODO: Add all files used to generate to the input/

    // Get the output directory
    let outputDir = context.pluginWorkDirectory.appending(["SacogeGenerated"])
    let outputFilePath = outputDir.appending(["Sacoge.gen.swift"])
    outputFiles.append(outputFilePath)

    // Create the directory where the file will be generated
    try FileManager.default.createDirectory(
      atPath: outputDir.string,
      withIntermediateDirectories: true
    )

    // Arguments to pass to `sacoge`
    let args: [String] = [
      "generate",
      "--output",
      outputFilePath.string,
    ]

    return [
      .buildCommand(
        displayName: """
        [SacogePlugin]
        sacoge \(args.joined(separator: " "))
        """,
        executable: sacoge.path,
        arguments: args,
        inputFiles: inputFiles,
        outputFiles: outputFiles
      )
    ]
  }
}
