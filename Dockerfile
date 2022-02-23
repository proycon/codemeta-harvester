FROM alpine:latest
RUN apk add python3 py3-pip py3-yaml py3-ruamel.yaml git dasel
#TODO: replace with stable version after codemetapy release --------------v
RUN python3 -m pip install  --no-cache-dir --prefix /usr git+https://github.com/proycon/codemetapy.git cffconvert somef
COPY codemeta-harvester /usr/bin/
ENTRYPOINT ["codemeta-harvester"]
