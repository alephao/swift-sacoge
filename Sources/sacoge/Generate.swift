import ArgumentParser
import Foundation
import SacogeCore

private func commmonRun(
  options: GenerateOptions,
  _ gen: @escaping (Configuration) throws -> String
) throws {
  let configuration = try loadConfiguration(path: options.configuration)
  let generated = try gen(configuration)
  if let output = options.output {
    try generated.write(toFile: output, atomically: true, encoding: .utf8)
  } else {
    print(generated)
  }
}

extension SacogeCommand {
  struct Generate: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Generate everything",
      aliases: ["gen"]
    )

    @OptionGroup()
    var options: GenerateOptions

    func run() throws {
      try commmonRun(options: options) { config in
        try Generator(configuration: config).generate()
      }
    }
  }
}

extension SacogeCommand.Generate {
  struct Definitions: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Generates only the type definitions",
      aliases: ["defs"]
    )

    @OptionGroup()
    var options: GenerateOptions

    func run() throws {
      try commmonRun(options: options) { config in
        Generator.TypeDefinitions(configuration: config).generate()
      }
    }
  }
}

extension SacogeCommand.Generate {
  struct References: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Generates only the static references",
      aliases: ["refs"]
    )

    @OptionGroup()
    var options: GenerateOptions

    func run() throws {
      try commmonRun(options: options) { config in
        try Generator.StaticReferences(configuration: config).generate()
      }
    }
  }
}

extension SacogeCommand.Generate {
  struct Mappings: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Generates only the dictionary mappings",
      aliases: ["maps"]
    )

    @OptionGroup()
    var options: GenerateOptions

    func run() throws {
      try commmonRun(options: options) { config in
        try Generator.Mapping(configuration: config).generate()
      }
    }
  }
}
