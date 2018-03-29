DIST ?= alpine
ARCH ?= amd64
TAG ?= latest
REPO ?= local/rclone-mount

generate:
	@./generate.sh

build: $(DIST)/$(ARCH)/$(TAG)/Dockerfile
	@echo "Building $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT) using $(DIST)/$(ARCH)/$(TAG)/Dockerfile"
	@docker build $(BUILD_OPTS) $(DIST)/$(ARCH)/$(TAG)/ -f $(DIST)/$(ARCH)/$(TAG)/Dockerfile -t $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT)
	@docker images | grep "$(REPO)"

login:
	@echo "$(DOCKER_PASSWORD)" | docker login -u="$(DOCKER_USERNAME)" --password-stdin

logout:
	@docker logout

pull:
	@docker pull $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT)

push:
	@echo "Pushing $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT)"
	@docker push $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT)

save:
	@mkdir -p .images
	@docker save --output .images/$(DIST)_$(TAG)_$(ARCH)$(VARIANT).tar $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT)

tag:
	@echo "Tagging $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT) to $(REPO):$(DIST)_$(TAG)_$(ARCH)"
	@docker tag $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT) $(REPO):$(DIST)_$(TAG)_$(ARCH)

run:
	@docker run --rm --name local-rclone-mount $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT) rclone --version

run-shell:
	@docker run -it --rm $(RUN_OPTS) $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT) /bin/bash

test: build
	@echo "Testing  $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT)"
	@./container-structure-test -test.timeout 10s -test.v -image $(REPO):$(DIST)_$(TAG)_$(ARCH)$(VARIANT) structure-test/tests-$(ARCH).yaml

