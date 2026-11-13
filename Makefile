
NAME = Inception
COMPOSE_FILE = ./srcs/docker-compose.yml
DOCKER_COMPOSE = docker compose -f $(COMPOSE_FILE)

all: up

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down

start:
	$(DOCKER_COMPOSE) start

stop:
	$(DOCKER_COMPOSE) stop

restart:
	$(DOCKER_COMPOSE) restart

logs:
	$(DOCKER_COMPOSE) logs -f

ps:
	$(DOCKER_COMPOSE) ps -a

clean: down

re: down up

.PHONY: all build up down start stop restart logs ps clean re

