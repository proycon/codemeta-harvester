check:
	shellcheck codemeta-harvester *.sh

env:
	python3 -m venv env
	. env/bin/activate
	pip install git+https://github.com/proycon/codemetapy.git cffconvert
