FROM alpine:3.21

#you may set this to something like: git+https://github.com/proycon/codemetapy.git@master  if you want to use a development version of codemetapy instead of the latest release
ARG CODEMETAPY_VERSION="stable"

RUN apk add python3 py3-pip py3-yaml py3-ruamel.yaml py3-requests py3-matplotlib py3-markdown py3-rdflib py3-lxml py3-wheel cython git dasel curl recode gawk pandoc

ENV GIT_TERMINAL_PROMPT=0

RUN if [ "$CODEMETAPY_VERSION" = "stable" ]; then \
        python3 -m pip install  --no-cache-dir --prefix /usr codemetapy cffconvert; \
    else \
        python3 -m pip install  --no-cache-dir --prefix /usr $CODEMETAPY_VERSION cffconvert; \
    fi
COPY codemeta-harvester /usr/bin/
COPY *.sh /usr/bin/

WORKDIR /data

ENTRYPOINT ["codemeta-harvester"]
