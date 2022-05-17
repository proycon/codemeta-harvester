.PHONY: check docker env devenv

check:
	shellcheck codemeta-harvester *.sh

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
