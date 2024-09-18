import Crypto
import Foundation

func bytes4(_ text: String) -> String {
  let data = text.data(using: .utf8)!
  return bytes4(data)
}

func bytes4(_ data: Data) -> String {
  let hashed = SHA256.hash(data: data)
  let first4bytes = hashed.prefix(4)
  return first4bytes.map({ String($0.bigEndian, radix: 16) }).joined()
}
