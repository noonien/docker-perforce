FROM ubuntu:18.04
LABEL maintainer="George Jiglau <george@mux.ro>"

ENV DEBIAN_FRONTEND noninteractive

# Update package list and install wget
RUN apt-get update && apt-get install -y wget gnupg2 && \
    # Get perforce packages
    wget -q http://package.perforce.com/perforce.pubkey -O - | apt-key add - && \
    echo 'deb http://package.perforce.com/apt/ubuntu bionic release' > /etc/apt/sources.list.d/perforce.sources.list && \
    # clean up the layer.
    rm -rf /var/log/* \
    rm -rf /var/lib/apt/lists/*

