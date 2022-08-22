.PHONY: check docker env devenv docker-dev docker

check:
	shellcheck codemeta-harvester *.sh

docker-dev:
	docker build -t proycon/codemeta-harvester:dev --build-arg CODEMETAPY_VERSION=git+https://github.com/proycon/codemetapy.git@master .

docker:
	docker build -t proycon/codemeta-harvester .

env:
	python3 -m venv env
	. env/bin/activate
	cp codemeta-harvester *.sh env/bin
	pip install codemetapy cffconvert

devenv:
	python3 -m venv devenv
	. devenv/bin/activate
	cp codemeta-harvester *.sh devenv/bin
	pip install git+https://github.com/proycon/codemetapy.git cffconvert
