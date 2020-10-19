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

down:
	docker-compose down

push:
	docker-compose push app

exec:
	docker-compose exec -it app /bin/sh

logs:
	docker-compose logs app

deploy:
	@echo WARNING! Make sure we have configured AWS CLI `aws configure`
	cd infrastructure/ecs-stack; terraform init
	cd infrastructure/ecs-stack; terraform apply

auto-deploy:
	cd infrastructure/ecs-stack; terraform init
	cd infrastructure/ecs-stack; terraform apply -auto-approve

destroy:
	@echo WARNING! Make sure we delete all running ECS tasks
	@echo Otherwise deployment will hang for a long time and fail
	cd infrastructure/ecs-stack; terraform destory
