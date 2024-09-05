include src/.env

THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: build rebuild rebuild-app up it migrate migrate-rollback migrate-fresh migration composer-install composer-update composer-du npm-install npm-update npm-build npm-host docker-build

app := $(COMPOSE_PROJECT_NAME)-php
nginx := $(COMPOSE_PROJECT_NAME)-nginx
mysql := $(COMPOSE_PROJECT_NAME)-mysql
app-npm := npm
path := /usr/src

#docker
build:
	docker-compose -f docker-compose.yml --env-file src/.env up --build -d $(c)
rebuild:
	docker-compose up -d --force-recreate --no-deps --build $(r)
rebuild-app:
	docker-compose up -d --force-recreate --no-deps --build $(app)
up:
	docker-compose -f docker-compose.yml --env-file src/.env up -d $(c)
stop:
	docker-compose -f docker-compose.yml --env-file src/.env stop $(c)
it:
	docker exec -it $(to) /bin/bash
it-app:
	docker exec -it $(app) /bin/bash
it-nginx:
	docker exec -it $(nginx) /bin/bash
it-mysql:
	docker exec -it $(mysql) /bin/bash

up-prod:
	docker-compose -f docker-compose.prod.yml down
	docker-compose -f docker-compose.prod.yml up -d $(c)

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

#сбор контейнеров на локальном окружении
docker-build:
	sudo rm -rf src/vendor
	sudo rm -rf src/node_modules
	sudo rm -f src/bootstrap/cache/*.php
	#build
	docker build -t $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-php:$(tag) --target=prod --build-arg user=$(DOCKER_USER) --build-arg uid=1000 -f docker/dockerfiles/php.Dockerfile .
	docker build -t $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-scheduler:$(tag) --target=scheduler --build-arg user=$(DOCKER_USER) --build-arg uid=1000 -f docker/dockerfiles/php.Dockerfile .
	docker build -t $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-nginx:$(tag) --target=prod -f docker/dockerfiles/nginx.Dockerfile .
	docker build -t $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-mysql:$(tag) --build-arg password=$(DB_PASSWORD) -f docker/dockerfiles/mysql.Dockerfile .
	#push
	docker push $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-php:$(tag)
	docker push $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-scheduler:$(tag)
	docker push $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-nginx:$(tag)
	docker push $(DOCKER_HUB_USER)/$(COMPOSE_PROJECT_NAME)-mysql:$(tag)