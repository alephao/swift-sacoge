fmt:
	swift-format format -i -r -p Sources Package.swift

test:
	swift test

test-linux-swift508:
	docker compose run --rm --build swift508

test-linux-swift509:
	docker compose run --rm --build swift509

test-linux-swift510:
	docker compose run --rm --build swift510

test-linux-swift600:
	docker compose run --rm --build swift600

test-linux-all:
	docker compose run --rm --build

.PHONY: fmt \
	test \
	test-linux-swift508 \
	test-linux-swift509 \
	test-linux-swift510 \
	test-linux-swift600 \
	test-linux-all
