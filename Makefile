PROJECT := kazoo-builder
DOCKER_ORG := telephoneorg
DOCKER_USER := joeblackwaslike
DOCKER_IMAGE := $(DOCKER_ORG)/$(PROJECT):latest

KAZOO_BRANCH ?= 4.2

.PHONY: build export clean

build:
	@docker build -t $(DOCKER_IMAGE) \
		--build-arg KAZOO_BRANCH=$(KAZOO_BRANCH) .

export:
	@docker run -it --rm \
		-v "$(PWD)/export:/export" \
		$(DOCKER_IMAGE) \
		cp kazoo.v$(KAZOO_BRANCH).tar.gz doc/sup_commands.txt /export

clean:
	@rm -rf export/{*.tar.gz,*.txt}
