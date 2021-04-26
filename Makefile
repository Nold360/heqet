# Build Docs
IMAGE=squidfunk/mkdocs-material
default: build

build:
	docker run --rm -it -v ${PWD}:/docs ${IMAGE} build

dev:
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs ${IMAGE}
