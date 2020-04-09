FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget gnupg2 curl apt-utils && wget -qO - https://package.perforce.com/perforce.pubkey | apt-key add - && echo 'deb http://package.perforce.com/apt/ubuntu bionic release' > /etc/apt/sources.list.d/perforce.sources.list && apt-get install -y helix-p4d=2019.2-1942501~bionic && rm -rf /var/log/* && rm -rf /var/lib/apt/lists/*

COPY run.sh /
CMD ["/run.sh"]