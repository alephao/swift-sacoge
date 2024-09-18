import InlineSnapshotTesting
import SacogeCore

final class GeneratorypeDefinitionsTests: GeneratorTestCase {
  func testGenerated() throws {
    let generator = Generator.TypeDefinitions(configuration: Configuration())
    let generated = generator.generate()
    assertInlineSnapshot(of: generated, as: .lines) {
      """
      public struct Asset: Sendable, CustomStringConvertible {
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
