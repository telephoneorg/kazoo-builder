PROJECT := kazoo-builder
DOCKER_ORG := telephoneorg
DOCKER_USER := joeblackwaslike
DOCKER_IMAGE := $(DOCKER_ORG)/$(PROJECT):latest

.PHONY: all build-builder build clean

all: build-builder build

build-builder:
	@docker build -t $(DOCKER_IMAGE) images/builder

build:
	@docker run -it --rm \
		-v "$(PWD)/dist:/dist" \
		--env-file images/builder/versions.env \
		$(DOCKER_IMAGE)

clean:
	@rm -rf dist/{*.tar.gz,*.txt,*.deb}
