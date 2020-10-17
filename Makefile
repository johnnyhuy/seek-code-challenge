#!/usr/bin/make

export BUILDKIT_PROGRESS=plain
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

build:
	docker-compose build

up:
	docker-compose up -d

# TODO: Terraform apply
