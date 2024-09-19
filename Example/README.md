# Sacoge Hummingbird Example

This example server uses `Sacoge` and `Sacoge Hummingbird` to serve assets.

The server has a custom sacoge configuration [here](.sacoge) and sets up the `SacogeMiddleware` [here](Sources/Example/Application+build.swift). There is one route, the root route `/`. The root route serves an html document with an `<img>` element referencing `Asset.swift_png`.

## Running

* If you run in DEBUG mode (`swift run`), assets are served with `no-cache`
* If you run in RELEASE mode (`swift run -c release`), assets are served with an immutable cache policy

> ⚠️ **Xcode**: If you want to run the project on Xcode, you need to update the `Example` scheme, edit the scheme, go to `Run > Options > Working Directory` and set the value to the root of this project.

After startin the server, open [`localhost:8080`](http://localhost:8080), it serves the [`swift.png`](my_public_folder/swift.png) image, check the Network logs to and see Cache-Control header.
