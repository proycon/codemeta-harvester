.PHONY: check docker env

check:
	shellcheck codemeta-harvester *.sh

docker:
	docker build -t proycon/codemeta-harvester .

env:
	python3 -m venv env
	. env/bin/activate
	cp codemeta-harvester *.sh env/bin
	pip install git+https://github.com/proycon/codemetapy.git cffconvert
