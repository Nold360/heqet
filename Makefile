
default: build

build:
	docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build

deploy:
	docker run --rm -it -v ~/.ssh:/root/.ssh -v ${PWD}:/docs squidfunk/mkdocs-material gh-deploy

dev:
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
