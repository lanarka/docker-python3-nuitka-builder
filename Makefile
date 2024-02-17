.PHONY: di-clean di-build clean build start start-shell start-dev run

di-build:
	docker build -f py3builder/Dockerfile -t py3builder/py3builder .

di-clean:
	docker rmi py3builder/py3builder

build:
	docker build -f py3builder/Dockerfile -t py3builder/py3builder .
	docker volume create volume1

	docker run -d --rm --name dummy -v volume1:/root alpine tail -f /dev/null
	docker cp src/ dummy:/root/src/
	docker stop dummy

	docker run --rm -v volume1:/data -it py3builder/py3builder \
		python3 -m nuitka --plugin-enable=multiprocessing \
						  --follow-imports --show-progress /data/src/_main.py \
						  --standalone --output-dir=/data/ \
						  --plugin-enable=pyqt5

	docker run -d --rm --name dummy -v volume1:/root alpine tail -f /dev/null
	docker cp dummy:/root/_main.dist dist
	docker stop dummy

clean: 
	docker volume rm volume1
	rm -rf dist/

start-dev:
	docker run -d --rm --name dummy -v volume1:/root alpine tail -f /dev/null
	docker cp src/ dummy:/root/src/
	docker stop dummy
	docker run --rm -v volume1:/data -it --net=host --env DISPLAY=${DISPLAY} py3builder/py3builder python3 ./data/src/_main.py

start:
	docker run --rm -v volume1:/data -it --net=host --env DISPLAY=${DISPLAY} py3builder/py3builder ./data/_main.dist/_main

start-shell:
	docker run --rm -v volume1:/data -it --net=host --env DISPLAY=${DISPLAY} py3builder/py3builder bash

run:
	python3 src/_main.py
