FROM debian:stable-slim

RUN apt-get update -qqy && apt-get install -qqy python3 python3-pip \ 
python3-yaml python3-ruamel.yaml python3-requests python3-matplotlib python3-markdown python3-rdflib python3-lxml python3-wheel \
git curl recode gawk pandoc && \
apt-get clean -qqy ; apt-get autoremove --yes ; rm -rf /var/lib/{apt,dpkg,cache,log}/

#dasel cython
RUN curl -sSLf "$(curl -sSLf https://api.github.com/repos/tomwright/dasel/releases/latest | grep browser_download_url | grep linux_amd64 | grep -v .gz | cut -d\" -f 4)" -L -o dasel && \
chmod +x dasel && \
mv ./dasel /usr/local/bin/dasel

ENV GIT_TERMINAL_PROMPT=0
#TODO: replace with stable version after codemetapy release --------------v
ARG CODEMETAPY_REPO_URL=https://github.com/xmichele/codemetapy.git
RUN python3 -m pip install  --no-cache-dir --prefix /usr Cython git+$CODEMETAPY_REPO_URL cffconvert
COPY codemeta-harvester /usr/bin/
COPY *.sh /usr/bin/

WORKDIR /data
ENTRYPOINT ["codemeta-harvester"]