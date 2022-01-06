FROM alpine:latest
RUN apk add python3 py3-pip py3-yaml py3-ruamel.yaml git dasel
RUN python3 -m pip install  --no-cache-dir --prefix /usr codemetapy cffconvert
COPY codemeta-harvester /usr/bin/
ENTRYPOINT ["codemeta-harvester"]
