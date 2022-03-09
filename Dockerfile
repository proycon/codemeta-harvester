FROM alpine:latest
RUN apk add python3 py3-pip py3-yaml py3-ruamel.yaml py3-requests py3-scikit py3-pandas py3-matplotlib py3-markdown py3-rdflib git dasel pandoc
#TODO: replace with stable version after codemetapy release --------------v
RUN python3 -m pip install  --no-cache-dir --prefix /usr git+https://github.com/proycon/codemetapy.git cffconvert somef
COPY codemeta-harvester /usr/bin/
ENTRYPOINT ["codemeta-harvester"]
