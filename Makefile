PROJECT = kazoo-builder
DOCKER_USER ?= callforamerica
DOCKER_IMAGE = $(DOCKER_USER)/$(PROJECT)
ORG ?= sip-li

.PHONY: build export clean

build:
	@docker build -t $(DOCKER_IMAGE) .

export:
	@docker create --name $(PROJECT) $(DOCKER_IMAGE) sleep
	@docker cp $(PROJECT):/opt/kazoo/kazoo.tar.gz export/
	@docker rm $(PROJECT)

clean:
	@rm -rf export/*.tar.gz
