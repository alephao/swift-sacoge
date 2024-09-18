import SacogeCore
import XCTest

class GeneratorTestCase: XCTestCase {
  private var tmpdir: URL!
  private(set) var rootDirectory: String!
  var configuration: Configuration!

  override func setUpWithError() throws {
    tmpdir = try FileManager.default.url(
      for: .itemReplacementDirectory,
      in: .userDomainMask,
      appropriateFor: FileManager.default.temporaryDirectory,
      create: true
    )
    rootDirectory = tmpdir.appendingPathComponent("my_public_files", isDirectory: true).path
    configuration = Configuration(
      from: "/static/immutable/",
      to: "my_public_files/",
      structName: "MyAsset",
      ignore: [
        "ignore_this.txt",
        "ignore_dir",
      ],
      skipChecksum: [
        "no_checksum_dir",
        "level1-nochecksum.txt",
        "level2-nochecksum.txt",
        "level3-nochecksum.txt",
      ]
    )

    // Special chars
    try touch("my_public_files/with-dash.txt")
    try touch("my_public_files/with_underscore.txt")
    try touch("my_public_files/with_at@3x.txt")

    // Ignore
    try touch("my_public_files/ignore_this.txt")
    try touch("my_public_files/ignore_dir/foo.txt")
    try touch("my_public_files/ignore_dir/bar.txt")

    // No checksum
    try touch("my_public_files/no_checksum.txt")

    // No checksum dir
    try touch("my_public_files/no_checksum_dir/no_checksum_via_dir.txt")

    // Deep
    try touch("my_public_files/deep/level1.txt")
    try touch("my_public_files/deep/level1-nochecksum.txt")
    try touch("my_public_files/deep/deep2/level2.txt")
    try touch("my_public_files/deep/deep2/level2-nochecksum.txt")
    try touch("my_public_files/deep/deep2/deep3/level3.txt")
    try touch("my_public_files/deep/deep2/deep3/level3-nochecksum.txt")

    FileManager.default.changeCurrentDirectoryPath(tmpdir.path)
  }

  override func tearDownWithError() throws {
    try FileManager.default.removeItem(at: tmpdir)
  }
}

extension GeneratorTestCase {
  /// Returns a URL to a file or directory in the test's temporary space.
  private func tmpURL(_ path: String) -> URL {
    return tmpdir.appendingPathComponent(path, isDirectory: false)
  }

  /// Create an empty file at the given path in the test's temporary space.
  private func touch(_ path: String) throws {
    let fileURL = tmpURL(path)
    try FileManager.default.createDirectory(
      at: fileURL.deletingLastPathComponent(),
      withIntermediateDirectories: true
    )
    FileManager.default.createFile(
      atPath: fileURL.path,
      contents: Data()
    )
  }
}
