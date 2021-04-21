# Build Docs
IMAGE=local/mkdocs
default: image build

image:
	docker build -t ${IMAGE} .

build:
	docker run --rm -it -v ${PWD}:/docs ${IMAGE} build

deploy:
	docker run --rm -it -v ~/.ssh:/home/nold/.ssh -v ${PWD}:/docs ${IMAGE} gh-deploy

dev:
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs ${IMAGE}
