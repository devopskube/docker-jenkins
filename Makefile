IMAGE_NAME=$(shell grep -A0 'imageName:' project.yml | tail -n1 | awk '{print $$2}')
VERSION=$(shell grep -A0 'version:' project.yml | tail -n1 | awk '{print $$2}')
PART ?= "image_version"

all: build

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build       - build the image"
	@echo "   2. make quickstart  - start the image"
	@echo "   3. make stop        - stop the image"
	@echo "   4. make logs        - view logs"
	@echo "   5. make purge       - stop and remove the container"
	@echo "   6. make bump        - bump the version of this container"

build:
	@docker build --tag=${IMAGE_NAME} .

release:
	@docker build --tag=${IMAGE_NAME}:${VERSION} .

push:
	@docker push ${IMAGE_NAME}:${VERSION}

quickstart:
	@echo "Starting jenkins..."
	@docker run --name=jenkins -d -p 10080:80 \
		-v /var/run/docker.sock:/run/docker.sock \
		-v $(shell which docker):/bin/docker \
		devopskube/jenkins:latest >/dev/null
	@echo "Please be patient. This could take a while..."
	@echo "Jenkins will be available at http://localhost:8080"
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping jenkins..."
	@docker stop jenkins >/dev/null

purge: stop
	@echo "Removing stopped container..."
	@docker rm jenkins >/dev/null

logs:
	@docker logs -f jenkins

.PHONY: bump
bump:
	@echo "Bumping Version"
	bumpversion ${PART}
	git push
	git push origin --tags
