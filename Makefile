fmt:
	swift-format format -i -r -p Sources Package.swift

build-and-install:
	swift build -c release
	sudo cp .build/release/sacoge /usr/local/bin/

test:
	swift test

test-linux-swift600:
	docker compose run --rm --build swift600

test-linux-all:
	docker compose run --rm --build

.PHONY: fmt \
	test \
	test-linux-swift600 \
	test-linux-all
