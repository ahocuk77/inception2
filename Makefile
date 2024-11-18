all: up

up:
	mkdir /home/ahocuk/data/mariadb || true
	sudo docker compose -f./srcs/docker-compose.yml up -d

list:
	sudo docker ps -a

stop:
	sudo docker container stop $$(sudo docker ps -q)

down:
	sudo docker compose -f ./srcs/docker-compose.yml down

down_v:
	sudo docker compose -f ./srcs/docker-compose.yml -v down

rm:
	sudo docker container rm $$(sudo docker ps -a -q)
	sudo docker image rm $$(sudo docker images -q)
	sudo docker volume rm $$(sudo docker volume ls -q)

clean_mem:
	sudo rm -rf /home/ahocuk/data/mariadb/
