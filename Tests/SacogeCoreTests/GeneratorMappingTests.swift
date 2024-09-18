import InlineSnapshotTesting
import SacogeCore

final class GeneratorMappingTests: GeneratorTestCase {
  func testGenerated() throws {
    let generator = try Generator.Mapping(configuration: configuration)
    let generated = generator.generate()
    assertInlineSnapshot(of: generated, as: .lines) {
      """
      extension MyAsset {
        public static let externalToInternalMapping: [String: String] = [
          MyAsset.no_checksum_dir.no_checksum_via_dir_txt.externalPath: MyAsset.no_checksum_dir.no_checksum_via_dir_txt.internalPath,
          MyAsset.no_checksum_txt.externalPath: MyAsset.no_checksum_txt.internalPath,
          MyAsset.deep.level1_nochecksum_txt.externalPath: MyAsset.deep.level1_nochecksum_txt.internalPath,
          MyAsset.deep.level1_txt.externalPath: MyAsset.deep.level1_txt.internalPath,
          MyAsset.deep.deep2.level2_txt.externalPath: MyAsset.deep.deep2.level2_txt.internalPath,
          MyAsset.deep.deep2.level2_nochecksum_txt.externalPath: MyAsset.deep.deep2.level2_nochecksum_txt.internalPath,
          MyAsset.deep.deep2.deep3.level3_txt.externalPath: MyAsset.deep.deep2.deep3.level3_txt.internalPath,
          MyAsset.deep.deep2.deep3.level3_nochecksum_txt.externalPath: MyAsset.deep.deep2.deep3.level3_nochecksum_txt.internalPath,
          MyAsset.with_dash_txt.externalPath: MyAsset.with_dash_txt.internalPath,
          MyAsset.with_underscore_txt.externalPath: MyAsset.with_underscore_txt.internalPath,
          MyAsset.with_at_3x_txt.externalPath: MyAsset.with_at_3x_txt.internalPath
        ]
      }
      """
    }
  }
}
