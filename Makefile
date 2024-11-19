.SILENT:

# Main Target
all: up

# Create necessary directories and start Docker Compose
up:
	# Check if the MariaDB data directory exists, if not, create it
	@if [ ! -d "/home/ahocuk/data/mariadb" ]; then \
		echo "Creating /home/ahocuk/data/mariadb directory..."; \
		mkdir -p /home/ahocuk/data/mariadb; \
	fi

	# Check if the WordPress data directory exists, if not, create it
	@if [ ! -d "/home/ahocuk/data/wordpress" ]; then \
		echo "Creating /home/ahocuk/data/wordpress directory..."; \
		mkdir -p /home/ahocuk/data/wordpress; \
	fi

	# Start services in detached mode
	sudo docker compose -f ./srcs/docker-compose.yml up -d

# List all Docker containers (running and stopped)
list:
	sudo docker ps -a

# Stop all running Docker containers
stop:
	echo "Stopping all running Docker containers..."; \
	sudo docker container stop $$(sudo docker ps -q)        # Stops all active containers

# Stop and remove containers, networks, and volumes
down:
	echo "Stopping and removing containers, networks, and volumes..."; \
	sudo docker compose -f ./srcs/docker-compose.yml down

# Stop and remove containers, networks, and **all** volumes
down_v:
	echo "Stopping and removing containers, networks, and all volumes..."; \
	sudo docker compose -f ./srcs/docker-compose.yml down -v

# Remove all Docker containers, images, and volumes
rm:
	@if [ -n "$$(sudo docker ps -q)" ]; then \
		$(MAKE) stop; \
	fi
	@if [ -n "$$(sudo docker ps -a -q)" ]; then \
		echo "Stopping and removing containers..."; \
		sudo docker container rm $$(sudo docker ps -a -q); \
	else \
		echo "No containers to remove."; \
	fi
	@if [ -n "$$(sudo docker images -q)" ]; then \
		echo "Removing images..."; \
		sudo docker image rm $$(sudo docker images -q); \
	else \
		echo "No images to remove."; \
	fi
	@if [ -n "$$(sudo docker volume ls -q)" ]; then \
		echo "Removing volumes..."; \
		sudo docker volume rm $$(sudo docker volume ls -q); \
	else \
		echo "No volumes to remove."; \
	fi

# Clean up project-specific data directories
clean_mem:
	@if [ -n "$$(sudo docker ps -q)" ]; then \
	echo "Stopping all running containers..."; \
		$(MAKE) stop; \
	fi
	echo "Clearing MariaDB data..."; \
	sudo rm -rf /home/ahocuk/data/mariadb/                  # Clear MariaDB data
	echo "Clearing WordPress data..."; \
	sudo rm -rf /home/ahocuk/data/wordpress/                # Clear WordPress data

# Additional Commands
# Restart all containers (useful for debugging or refreshing)
restart:
	echo "Stopping and restarting all containers..."; \
	$(MAKE) stop
	$(MAKE) up

# Prune all unused Docker objects (containers, images, networks, and volumes)
prune:
	echo "Pruning unused Docker objects..."; \
	sudo docker system prune -af                            # Aggressively prune Docker system
	sudo docker volume prune -f                             # Remove dangling volumes

# Check Docker disk usage
disk_usage:
	sudo docker system df                                   # Show Docker disk usage

# Logs for all containers
logs:
	sudo docker compose -f ./srcs/docker-compose.yml logs -f # Follow logs for all services

