include .env

THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: build rebuild rebuild-app up it migrate migrate-rollback migrate-fresh migration composer-install composer-update composer-du npm-install npm-update npm-build npm-host

app := $(COMPOSE_PROJECT_NAME)-php
app-npm := npm
path := /usr/src

#docker
build:
	docker-compose -f docker-compose.yml up --build -d $(c)
rebuild:
	docker-compose up -d --force-recreate --no-deps --build $(r)
rebuild-app:
	docker-compose up -d --force-recreate --no-deps --build $(app)
up:
	docker-compose -f docker-compose.yml up -d $(c)
it:
	docker exec -it $(app) /bin/bash

#laravel
migrate:
	docker exec $(app) php $(path)/artisan migrate
migrate-rollback:
	docker exec $(app) php $(path)/artisan migrate:rollback
migrate-fresh:
	docker exec $(app) php $(path)/artisan migrate:fresh --seed
migration:
	docker exec $(app) php $(path)/artisan make:migration $(m)

#composer
composer-install:
	docker exec $(app) composer install
composer-update:
	docker exec $(app) composer update
composer-du:
	docker exec $(app) composer du

#npm
npm-install:
	docker-compose run --rm --service-ports $(app-npm) install $(c)
npm-update:
	docker-compose run --rm --service-ports $(app-npm) update $(c)
npm-build:
	docker-compose run --rm --service-ports $(app-npm) run build $(c)
npm-host:
	docker-compose run --rm --service-ports $(app-npm) run dev --host $(c)

docker-push:
	docker tag $(COMPOSE_PROJECT_NAME)-php $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-php:$(IMAGE_TAG)
	docker push $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-php:$(IMAGE_TAG)
	docker tag $(COMPOSE_PROJECT_NAME)-nginx $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-nginx:$(IMAGE_TAG)
	docker push $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-nginx:$(IMAGE_TAG)
	docker tag $(COMPOSE_PROJECT_NAME)-mysql $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-mysql:$(IMAGE_TAG)
	docker push $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-mysql:$(IMAGE_TAG)