#!/usr/bin/make

export BUILDKIT_PROGRESS=plain
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

build:
	docker-compose build

sync:
	make build
	make up

up:
	docker-compose up -d

exec:
	docker-compose exec -it app /bin/sh

logs:
	docker-compose logs app

# TODO: Terraform apply
