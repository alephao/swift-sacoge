import Foundation
import SacogeCore

func loadConfiguration(path: String?) throws -> Configuration {
  let configPath = path ?? ".sacoge"
  guard
    FileManager.default.fileExists(atPath: configPath)
  else { return Configuration() }

  let url = URL(fileURLWithPath: configPath)
  let data = try Data(contentsOf: url)
  let config = try JSONDecoder().decode(Configuration.self, from: data)
  return config
}
