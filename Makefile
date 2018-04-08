######
# Mibank Makefile
######
DEVSTACK_WORKSPACE ?= $(shell pwd)/..

export DEVSTACK_WORKSPACE

# Generates a help message. Borrowed from https://github.com/pydanny/cookiecutter-djangopackage.
help: ## Display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@perl -nle'print $& if m{^[\.a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

requirements: ## Install requirements
	pip install -r requirements.txt

dev.clone: ## Clone service repos to the parent directory
	./repo.sh clone

dev.build: ## Build docker images to use in dev environment
	./docker_compose_builder.sh

dev.ps: ## Displays the containers running
	docker-compose ps

dev.migrate: | dev.down ## Finish the current containers and migrate the db
	docker-compose run web python manage.py migrate

dev.up: ## Bring up all services with host volumes
	docker-compose up -d

dev.down: ## Bring up all services with host volumes
	docker-compose down

dev.django.logs: ## Print on screen django app container logs
	docker-compose logs web

dev.postgres.logs: ## Print on screen postgres container logs
	docker-compose logs db
