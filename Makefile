PROJECT = kazoo-builder

DOCKER_USER ?= callforamerica

DOCKER_IMAGE = $(DOCKER_USER)/$(PROJECT)

ORG ?= sip-li
TAG = $(shell git tag | sort -n | tail -1)

.PHONY: build export bump-tag release upload-release

build:
	@docker build -f Dockerfile.fix -t $(DOCKER_IMAGE) .

export:
	@docker create --name $(PROJECT) $(DOCKER_IMAGE) sleep
	@docker cp $(PROJECT):/opt/kazoo/kazoo.tar.gz export/
	@docker rm $(PROJECT)

bump-tag:
	@git tag -a $(shell echo $(TAG) | awk -F. '1{$$NF+=1; OFS="."; print $$0}') -m "New Release"

release:
	@-git push origin $(TAG)
	@github-release release --user $(USER) --repo $(PROJECT) --tag $(TAG)

upload-release:
	github-release upload --user $(ORG) --repo $(PROJECT) --tag $(TAG) \
		--name $(PROJECT).tar.gz --file export/$(PROJECT).tar.gz

clean:
	@rm -rf export/*.tar.gz
