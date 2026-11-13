# User Documentation

## 1. Project Overview

Inception is a web infrastructure project built using Docker Compose. It consists of three services:

- **NGINX:** Acts as the web server and the entry point to the website. It handles HTTPS connections using TLS.
- **WordPress:** Provides the website and its content management system. It runs with PHP-FPM.
- **MariaDB:** Stores the WordPress database, including users, posts, pages, and website settings.

Each service runs in its own Docker container and communicates with the other services through a dedicated Docker network.

## 2. Starting and Stopping the Project

Open a terminal in the project's root directory.

To build and start the entire infrastructure:

```bash
make
```

To stop and remove the containers and the project network:

```bash
make down
```

To start previously created containers:

```bash
make start
```

To stop the running containers without removing them:

```bash
make stop
```

To restart the services:

```bash
make restart
```

## 3. Accessing the Website

The website is available through HTTPS:

```text
https://sal-qur.42.fr
```

The WordPress administration dashboard is available at:

```text
https://sal-qur.42.fr/wp-admin
```

A valid WordPress account is required to access the administration dashboard.

## 4. Credentials

The project uses Docker secrets to provide sensitive passwords to the containers.

The secret files are stored locally in the `secrets/` directory:

- `db_password.txt`
- `db_root_password.txt`
- `db_admin_password.txt`
- `wp_admin_password.txt`

Environment configuration is stored in:

```text
srcs/.env
```

These files contain sensitive information and must not be shared publicly or committed to the Git repository.

To retrieve or update credentials, consult the local secret files and the project's configuration. Do not expose passwords in terminal screenshots, logs, or documentation.

## 5. Checking the Services

To check the status of the containers:

```bash
make ps
```

To display service logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

To follow logs continuously:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

To check the logs of a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs mariadb
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs nginx
```

A service should be running without repeated startup failures or unexpected errors.

## 6. Data Persistence

The project uses persistent storage for MariaDB and WordPress.

- MariaDB data is stored under `/home/sal-qur/data/mariadb`.
- WordPress files are stored under `/home/sal-qur/data/wordpress`.

This allows website data to remain available when containers are stopped or recreated.

**Important:** Do not manually delete these directories or remove persistent storage without creating and verifying a backup first.
