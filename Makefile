PROJECT := kazoo-builder

KAZOO_BRANCH ?= 4.2

.PHONY: build export clean

build:
	@docker build -t $(PROJECT) --build-arg KAZOO_BRANCH=$(KAZOO_BRANCH) .

export:
	@docker create --name $(PROJECT) $(PROJECT) sleep
	@docker cp $(PROJECT):/opt/kazoo/kazoo.v$(KAZOO_BRANCH).tar.gz export/
	@docker rm $(PROJECT)

clean:
	@rm -rf export/*.tar.gz
