import Foundation
import PackagePlugin

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

    var inputFiles: [URL] = []
    var outputFiles: [URL] = []

    // Check if configuration is available
    let configURL = context.package.directoryURL.appending(path: ".sacoge")
    let configExists = FileManager.default.fileExists(atPath: configURL.path())
    if configExists {
      inputFiles.append(configURL)
    }

    // Load configuration
    let config = try loadConfiguration(path: configURL.path())

    // Append input files
    let filesToIgnore = Set(config.ignore)
    let inputFilesToAdd = (FileManager.default.subpaths(atPath: config.to) ?? [])
      .filter({
        guard let first = $0.split(separator: "/").first else { return true }
        return !filesToIgnore.contains(String(first))
      })
      .map({
        context.package.directoryURL
          .appending(path: config.to.trimmingPrefix("./"))
          .appending(path: $0)
      })
    inputFiles.append(contentsOf: inputFilesToAdd)

    // Get the output directory
    let outputDir = context.pluginWorkDirectoryURL.appending(path: "SacogeGenerated")
    let outputFilePath = outputDir.appending(path: "Sacoge.gen.swift")
    outputFiles.append(outputFilePath)

    // Create the directory where the file will be generated
    try FileManager.default.createDirectory(
      at: outputDir,
      withIntermediateDirectories: true
    )

    // Arguments to pass to `sacoge`
    let args: [String] = [
      "generate",
      "--output",
      outputFilePath.path(),
    ]

    return [
      .buildCommand(
        displayName: "SacogePlugin",
        executable: sacoge.url,
        arguments: args,
        inputFiles: inputFiles,
        outputFiles: outputFiles
      )
    ]
  }
}
