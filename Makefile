PROJECT := kazoo-builder
DOCKER_ORG := telephoneorg
DOCKER_USER := joeblackwaslike
DOCKER_IMAGE := $(DOCKER_ORG)/$(PROJECT):latest

KAZOO_BRANCH ?= 4.1.39

.PHONY: all build-builder build clean

all: build-builder build

build-builder:
	@docker build -t $(DOCKER_IMAGE) \
		--build-arg KAZOO_BRANCH=$(KAZOO_BRANCH) images/builder

build:
	@docker run -it --rm \
		-v "$(PWD)/export:/export" \
		$(DOCKER_IMAGE)

clean:
	@rm -rf export/{*.tar.gz,*.txt,*.deb}
