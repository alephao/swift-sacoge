import InlineSnapshotTesting
import SacogeCore

final class GeneratorStaticReferencesTests: GeneratorTestCase {
  func testGenerated() throws {
    let generator = try Generator.StaticReferences(configuration: configuration)
    let generated = generator.generate()
    assertInlineSnapshot(of: generated, as: .lines) {
      """
      extension MyAsset {
        public enum _1_number {
          public static let _2_number_txt = Asset(
            internalPath: "1_number/2_number.txt",
            externalPath: "/static/immutable/1_number/2_number_e3b0c442.txt"
          )
        }
        public enum deep {
          public enum deep2 {
            public enum deep3 {
              public static let level3_nochecksum_txt = Asset(
                internalPath: "deep/deep2/deep3/level3-nochecksum.txt",
                externalPath: "/static/immutable/deep/deep2/deep3/level3-nochecksum.txt"
              )
              public static let level3_txt = Asset(
                internalPath: "deep/deep2/deep3/level3.txt",
                externalPath: "/static/immutable/deep/deep2/deep3/level3_e3b0c442.txt"
              )
            }
            public static let level2_nochecksum_txt = Asset(
              internalPath: "deep/deep2/level2-nochecksum.txt",
              externalPath: "/static/immutable/deep/deep2/level2-nochecksum.txt"
            )
            public static let level2_txt = Asset(
              internalPath: "deep/deep2/level2.txt",
              externalPath: "/static/immutable/deep/deep2/level2_e3b0c442.txt"
            )
          }
          public static let level1_nochecksum_txt = Asset(
            internalPath: "deep/level1-nochecksum.txt",
            externalPath: "/static/immutable/deep/level1-nochecksum.txt"
          )
          public static let level1_txt = Asset(
            internalPath: "deep/level1.txt",
            externalPath: "/static/immutable/deep/level1_e3b0c442.txt"
          )
        }
        public static let no_checksum_txt = Asset(
          internalPath: "no_checksum.txt",
          externalPath: "/static/immutable/no_checksum_e3b0c442.txt"
        )
        public enum no_checksum_dir {
          public static let no_checksum_via_dir_txt = Asset(
            internalPath: "no_checksum_dir/no_checksum_via_dir.txt",
            externalPath: "/static/immutable/no_checksum_dir/no_checksum_via_dir.txt"
          )
        }
        public static let with_dash_txt = Asset(
          internalPath: "with-dash.txt",
          externalPath: "/static/immutable/with-dash_e3b0c442.txt"
        )
        public static let with_at_3x_txt = Asset(
          internalPath: "with_at@3x.txt",
          externalPath: "/static/immutable/with_at@3x_e3b0c442.txt"
        )
        public static let with_underscore_txt = Asset(
          internalPath: "with_underscore.txt",
          externalPath: "/static/immutable/with_underscore_e3b0c442.txt"
        )
      }
      """
    }
  }
}
