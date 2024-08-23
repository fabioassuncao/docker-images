IMAGE?=ghcr.io/fabioassuncao/php
VERSION?=8.3
DOCKER_RUN:=docker run --rm ${IMAGE}:${VERSION}
DEFAULT_ARCHS?=linux/amd64

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "⚡ \033[34m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build docker image
	docker buildx build --load --platform $(DEFAULT_ARCHS) -t $(IMAGE):${VERSION} -f php/${VERSION}/Dockerfile php/${VERSION}/

release: ### Build and push image to Registry
	echo "Releasing: ${IMAGE}${VERSION}"
	docker buildx build --push --platform $(DEFAULT_ARCHS) -t $(IMAGE):${VERSION} -f php/${VERSION}/Dockerfile php/${VERSION}/

release-all: ### Build all PHP version and push image to Registry
	echo "Releasing all PHP version"
	VERSION=8.3 make release

test: ### Test image
	$(DOCKER_RUN) php -v
	$(DOCKER_RUN) sh -c "php -v | grep ${VERSION}"
	$(DOCKER_RUN) sh -c "nginx -t"

test-all: ### Test all image
	VERSION=8.3 make build test