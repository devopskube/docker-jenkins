
IMAGE_NAME=$(shell grep -A0 'imageName:' project.yml | tail -n1 | awk '{print $$2}')
PART ?= "patch"

.PHONY: build
build:
	@echo "Building image $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME):latest .

.PHONY: bump
bump:
	@echo "Bumping Version"
	bumpversion ${PART}
	git push
	git push origin --tags

