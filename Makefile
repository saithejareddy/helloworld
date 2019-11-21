# Override envars using -e
# make release -e NS=docker.io/juspay/test -e VERSION=1.2.3 -e IMAGE_NAME=docker-test

NS ?= docker.io/saithejak/jenkins-docker
VERSION ?= latest

IMAGE_NAME ?= sample
CONTAINER_NAME ?= sample
CONTAINER_INSTANCE ?= default

SOURCE_COMMIT := $(shell git rev-parse HEAD)

.PHONY: build push shell run start stop rm release

build: Dockerfile
	$(info Building $(NS)/$(IMAGE_NAME):$(VERSION) / git-head: $(SOURCE_COMMIT))
	docker build -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile --build-arg "SOURCE_COMMIT=$(SOURCE_COMMIT)" .

push:
	docker push $(NS)/$(IMAGE_NAME):$(VERSION)

shell:
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) /bin/sh

run:
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

start:
	docker run -d --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

stop:
	docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

rm:
	docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

default: build

