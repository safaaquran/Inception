
NAME = Inception
COMPOSE_FILE = ./srcs/docker-compose.yml
DOCKER_COMPOSE = docker compose -f $(COMPOSE_FILE)

DATA_DIR = /home/sal-qur/data

all:
	mkdir -p $(DATA_DIR)/mariadb
	mkdir -p $(DATA_DIR)/wordpress
	docker compose -f srcs/docker-compose.yml up -d --build

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

ps:
	$(DOCKER_COMPOSE) ps -a

clean: down

re: down up

.PHONY: all build up down start stop restart logs ps clean re

