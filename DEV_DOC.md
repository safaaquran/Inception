# Developer Documentation

## 1. Project Structure

The project is organized as follows:

```text
Inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── db_admin_password.txt
│   └── wp_admin_password.txt
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        ├── wordpress/
        └── nginx/
```

Each service has its own directory containing its Dockerfile and related configuration files.

## 2. Prerequisites

Before building the project, make sure the following tools are installed:

- Debian or another compatible Linux distribution.
- Docker Engine.
- Docker Compose.
- GNU Make.
- Git.

Verify the installations:

```bash
docker --version
docker compose version
make --version
git --version
```

## 3. Configuration

### Environment Variables

The environment configuration is stored in:

```text
srcs/.env
```

It includes variables such as:

- `DOMAIN_NAME`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_ADMIN_USER`
- `MYSQL_ADMIN_PASSWORD`

The `.env` file must exist locally before starting the infrastructure.

### Docker Secrets

Sensitive passwords are stored in individual files inside the `secrets/` directory.

The Compose configuration provides these files to the relevant services as Docker secrets.

Make sure all required secret files exist before building and starting the project.

Never commit `.env` or secret files to the Git repository.

## 4. Building and Launching

Run the following command from the project's root directory:

```bash
make
```

The Makefile invokes Docker Compose using:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

This builds the service images when needed and starts the containers in detached mode.

To build the images without starting the containers:

```bash
make build
```

## 5. Managing Containers

The following commands are useful during development.

Check the status of the services:

```bash
make ps
```

Display logs:

```bash
make logs
```

Display logs for a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs -f nginx
```

Open a shell inside a running container:

```bash
docker compose -f srcs/docker-compose.yml exec mariadb bash
docker compose -f srcs/docker-compose.yml exec wordpress bash
docker compose -f srcs/docker-compose.yml exec nginx bash
```

Stop the containers:

```bash
make stop
```

Start existing containers:

```bash
make start
```

Restart the services:

```bash
make restart
```

Stop and remove the containers and the project network:

```bash
make down
```

## 6. Managing Volumes and Data

The project uses persistent storage for two services:

- MariaDB: `/home/sal-qur/data/mariadb`
- WordPress: `/home/sal-qur/data/wordpress`

The Compose file declares the persistent storage resources and mounts them into the relevant containers.

To list Docker volumes:

```bash
docker volume ls
```

To inspect a volume:

```bash
docker volume inspect srcs_mariadb_data
docker volume inspect srcs_wordpress_data
```

To inspect the project's Docker network:

```bash
docker network ls
docker network inspect srcs_inception
```

**Warning:** Removing containers does not normally remove named volumes. However, `docker compose down -v` removes Compose-managed named volumes. Always verify that a separate backup exists before performing destructive operations.

## 7. Data Persistence and Backups

Persistent storage allows database records and WordPress files to survive container recreation.

The database contains WordPress information such as users, posts, pages, and settings. The WordPress storage contains the application files, themes, plugins, and uploads.

Before changing storage configuration or removing volumes:

1. Stop the relevant services.
2. Create a backup of the required data.
3. Verify that the backup archive is readable.
4. Perform the changes.
5. Start the services and verify that the original data is available.

Do not use `docker compose down -v` as a routine shutdown command.

## 8. Network Architecture

The services communicate through a dedicated Docker bridge network.

- NGINX receives external HTTPS connections on port `443`.
- NGINX communicates with WordPress through PHP-FPM.
- WordPress communicates with MariaDB on port `3306`.

Docker's internal DNS allows services to communicate using their Compose service names instead of fixed IP addresses.

MariaDB does not need to expose its database port to the host for communication between containers.

## 9. Development Notes

- Each service has its own Dockerfile.
- The Docker Compose file defines the services, networks, volumes, and secrets.
- NGINX is the only service exposed to the outside through port `443`.
- The website must be accessed using HTTPS.
- Avoid using the `latest` tag for base images or dependencies; use an explicitly selected version.
- Keep sensitive configuration files out of version control.
