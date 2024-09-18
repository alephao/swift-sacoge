import ArgumentParser
import Foundation
import SacogeCore

extension SacogeCommand {
  struct DumpConfiguration: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Dump the default configuration in JSON format to standard output"
    )

    func run() throws {
      let configuration = Configuration()
      do {
        let encoder = JSONEncoder()
        encoder.outputFormatting.insert(.prettyPrinted)
        encoder.outputFormatting.insert(.sortedKeys)

        let data = try encoder.encode(configuration)
        guard let jsonString = String(data: data, encoding: .utf8) else {
          // This should never happen, but let's make sure we fail more gracefully than crashing, just
          // in case.
          throw SacogeError(
            message: "Could not dump the default configuration: the JSON was not valid UTF-8"
          )
        }
        print(jsonString)
      } catch {
        throw SacogeError(message: "Could not dump the default configuration: \(error)")
      }
    }
  }
}
