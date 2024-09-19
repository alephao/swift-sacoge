# Sacoge - Static Assets Codegen
[![CI](https://github.com/alephao/swift-sacoge/actions/workflows/ci.yml/badge.svg)](https://github.com/alephao/swift-sacoge/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/alephao/swift-sacoge/graph/badge.svg?token=ozz8CKz1Rb)](https://codecov.io/gh/alephao/swift-sacoge)

> ⚠️  Work in progress

Sacoge is a swift package plugin that makes it easy to serve your Swift Server's assets with an immutable cache policy by generating static references to each asset and adding the asset content's hash to its file name.

By serving assets with an immutable cache policy you can considerably reduce the number of requests to your server.

If you're using [`hummingbird`](https://github.com/hummingbird-project/hummingbird), the [swift-sacoge-hummingbird](https://github.com/alephao/swift-sacoge-hummingbird) contains a middleware that works with sacoge's generated code.

## Getting started


1. Add sacoge to the package dependencies:

```swift
dependencies: [
  // ...
  .package(url: "https://github.com/alephao/swift-sacoge.git", from: "0.1.0"),
]
```

2. Configure your target with SacogePlugin and SacogeHummingbird.

```swift
.target(
  name: "MyTarget",
  plugins: [
    .plugin(name: "SacogePlugin", package: "swift-sacoge"),
  ]
)
```

3. Build

Now you can access the `Asset` type in your target, containing references to the assets inside the `public` folder.

## Configuration

To configure sacoge, create a file named `.sacoge` in the root of your project, here is an example with the default values. If you omit any of the keys, it will use the default value:

```json
{
  "from": "/",
  "to": "public",
  "structName": "Asset",
  "ignore": [],
  "skipChecksum": []
}
```

* **`from`**: The base request path to map to the file system's public directory. If the `from -> to` values are `/static/immutable/ -> public`, then requests incoming to `https://example.com/static/immutable/img.jpg` will look into the file system's `public/img.jpg`. Default: `"/"`
* **`to`**: The path to the directory containing the static assets. If the `from -> to` values are `/static/immutable/ -> public`, then requests incoming to `https://example.com/static/immutable/img.jpg` will look into the file system's `public/img.jpg`. Default: `"public"`
* **`structName`**: The name of the generated type that contains references to all assets. By default, if you have an asset in the root named `img.jpg` you can reference it in your swift code by using `Asset.img_jpg`. Setting `structName` will rename `Asset` to something else so you would access it via `{structName}.img_jpg`. Default `"Asset"`.
* **`ignore`**: An array with the name of files/dirs you want sacoge to ignore. It won't generate any references to the files/dirs specified here. It has to be the exact name of the file/dir like `img.jpg` or `images` (there are no suppport for globs yet). Default:  `[]`.
* **`skipChecksum`**: By default, every file will have its content's hash added to the `from` value, so `img.png` would have a `from` value of `img_abcd1234.jpg`. `skipChecksum` works like `ignore`, but instead not generating references, it won't add the checksum to the `from` file name. Default: `[]`.

## How it works 

Sacoge runs a swift package build plugin, it generate a bit of swift code to help handling static/immutable assets you want to serve. This is what it is generates:

1. A type `public struct Asset { ... }` with information about asset locations in the local file syestem and it external access path.
2. Instance of the `Asset` type for each asset inside your public assets folder, accessed via `Asset.{dir}.{myFile_ext}` e.g.: `Asset.img.my_img_png`. The first 4 bytes of a SHA-256 hash of the file contents is added to the external access path, so you can serve the asset with an `immutable` cache policy.
3. A static constant in `Assets` containing a dictionary mapping external paths to internal paths of every asset.

When referencing assets in swift code, you would following change:

```diff
func myImg() -> String {
  """
-  <img src="/img/my_img.jpg">
+  <img src="\(Asset.img.my_img_jpg)">
  """
}
```

If you get a request and want to know if there is an asset for that request, you can do the following:

```swift
// Some `Request` type that contains a URL with a PATH
let request: Request // you got this value from your server framework
guard let asset = Asset.externalToInternalMapping[request.uri.path] else {
  // The asset does not exits, or was ignored by sacoge (you can configure which assets to ignore)
}

// Contains the local file system path to the asset relative to your public folder
// Example: If you have an asset at `./public/my_img.png`, the internalPath is `/my_img.png`
asset.internalPath

// The external path used in the request URL to access the asset. Contains the same value as `request.uri.path` that you used above.
asset.externalPath
```
