*This activity has been created as part of the 42 curriculum by sal-qur.*

# Inception

## Description

Inception is a System Administration project from the 42 curriculum. Its goal is to introduce containerization and infrastructure management using Docker and Docker Compose.

The project consists of building and configuring a small infrastructure composed of multiple services, each running in its own Docker container.

The infrastructure includes:

- **NGINX:** Acts as the entry point to the infrastructure and serves the website over HTTPS using TLS.
- **WordPress:** Provides the website and runs with PHP-FPM.
- **MariaDB:** Stores the WordPress database.

The services communicate through a dedicated Docker network. Persistent data is stored in Docker named volumes so that it remains available even when containers are stopped or recreated.

## Project Description

### Docker Usage

Docker is used to package and run each service in an isolated container.

Each service has its own Dockerfile, which defines how its image is built. Docker Compose is used to describe and manage the complete infrastructure through `srcs/docker-compose.yml`.

The main design choices are:

- One dedicated container for each service.
- Custom Dockerfiles for building the service images.
- A dedicated bridge network for communication between containers.
- Named volumes for persistent database and website data.
- Docker secrets for sensitive credentials.
- Environment variables stored in a local `.env` file for configuration.
- NGINX as the only externally accessible entry point, through HTTPS on port 443.

### Virtual Machines vs Docker

A virtual machine virtualizes an entire operating system, including its own kernel, and generally requires more resources.

Docker containers share the host operating system kernel while isolating applications and their environments.

Containers are generally lighter and faster to start than virtual machines. However, they do not provide the same level of operating-system isolation as virtual machines.

In this project, a virtual machine is used as the required development environment, while Docker containers run the individual services inside it.

### Secrets vs Environment Variables

Environment variables provide a convenient way to configure applications without hardcoding configuration values into Dockerfiles.

However, environment variables are not designed to be a secure storage mechanism for sensitive credentials. They may be exposed through container inspection or process environments.

Docker secrets provide a mechanism for making sensitive information available to services as files, rather than directly embedding passwords in images or configuration files.

In this project, the `.env` file contains configuration variables, while sensitive credentials are provided through Docker secrets.

### Docker Network vs Host Network

A Docker bridge network allows containers to communicate with each other using their service names and internal IP addresses.

It provides network isolation from other networks and avoids requiring every service to expose its ports directly to the host.

Host networking removes this network isolation and makes a container share the host's network namespace.

This project uses a dedicated Docker bridge network so that NGINX, WordPress, and MariaDB can communicate internally. Only NGINX exposes the HTTPS entry point to the host.

### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are designed to persist data independently of container lifecycles.

Bind mounts connect a specific host filesystem path directly to a path inside a container. They provide more direct access to host files but depend on the host directory structure.

This project uses named volumes for persistent WordPress website files and MariaDB database files.

## Instructions

### Prerequisites

- A virtual machine running Debian or Alpine.
- Docker Engine.
- Docker Compose.
- Git.

### Configuration

1. Clone the project repository.
2. Configure the environment variables in `srcs/.env`.
3. Create the required Docker secret files in the `secrets/` directory.
4. Ensure that the required host data directories exist and have appropriate permissions.
5. Configure the local domain name `sal-qur.42.fr` to point to the virtual machine's IP address.

**Do not commit `.env` files containing sensitive information or secret files to the public repository.**

### Build and Run

From the root of the repository, run:

```bash
make
```

This builds the Docker images and starts the infrastructure using Docker Compose.

To stop and remove the containers and project network:

```bash
make down
```

To inspect the running services:

```bash
make ps
```

### Accessing the Website

The website is available at:

```text
https://sal-qur.42.fr
```

The WordPress administration panel is available at:

```text
https://sal-qur.42.fr/wp-admin
```

## Resources

### Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Dockerfile Reference](https://docs.docker.com/reference/dockerfile/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress Documentation](https://developer.wordpress.org/)
- [PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)
- [OpenSSL Documentation](https://docs.openssl.org/)

### AI Usage

AI tools were used as learning and development assistance throughout the project.

They were used to:

- Explain Docker, Docker Compose, networking, volumes, TLS, and related system administration concepts.
- Help understand Dockerfile instructions and service configuration.
- Assist with troubleshooting and interpreting container logs.
- Support the organization and review of project documentation.

All generated suggestions and explanations were reviewed, tested, and adapted during the implementation of the project. The final configuration and implementation remain the responsibility of the project author.
