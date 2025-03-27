DOCKER_COMPOSE_VERSION := v2.32.0
DOCKER_COMPOSE_PATH := .tools/docker-compose
DOCKER_COMPOSE_FILE := docker-compose-files/tools.yaml
REPO_NAME := backstage-app
VERSION := 0.1.0
TAG := $(VERSION)
export APP_NAME ?= my-backstage

.PHONY: all create-backstage-cli create-my-backstage build-my-backstage run-my-backstage run-yarn-cli clean

all: create-backstage-cli create-my-backstage build-my-backstage run-my-backstage

$(DOCKER_COMPOSE_PATH):
	@mkdir -p .tools
	@curl -L "https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-$(shell uname -s | tr '[:upper:]' '[:lower:]')-$(shell uname -m)" -o $(DOCKER_COMPOSE_PATH)
	@chmod +x $(DOCKER_COMPOSE_PATH)

create-backstage-cli: $(DOCKER_COMPOSE_PATH)
	$(DOCKER_COMPOSE_PATH) -f $(DOCKER_COMPOSE_FILE) build cli

create-my-backstage: create-backstage-cli
	@echo "$(APP_NAME)" | docker run --rm -i -w /app -v "$(PWD):/app" "$$($(DOCKER_COMPOSE_PATH) -f $(DOCKER_COMPOSE_FILE) config --images cli)" npx @backstage/create-app@latest
	@echo "Backstage app '$(APP_NAME)' created in ./$(APP_NAME)"

build-my-backstage:
	docker image build -f ./docker-files/backstage-dev/Dockerfile -t my-backstage-dev --progress=plain .

run-my-backstage: build-my-backstage
	docker run --rm -it -p 3000:3000 -p 7007:7007 -v "$(PWD)/$(APP_NAME):/app" -e NODE_ENV=development -e GITHUB_TOKEN="$(GITHUB_TOKEN)" my-backstage-dev

run-yarn-cli: build-my-backstage
	@if [ -z "$(COMMAND)" ]; then echo "Error: COMMAND is not set. Usage: make run-yarn-cli COMMAND=\"your-command-here\""; exit 1; fi
	docker run --rm -it -v "$(PWD)/$(APP_NAME):/app" my-backstage-dev yarn $(COMMAND)

clean: $(DOCKER_COMPOSE_PATH)
	$(DOCKER_COMPOSE_PATH) -f $(DOCKER_COMPOSE_FILE) down
	rm -rf .tools
