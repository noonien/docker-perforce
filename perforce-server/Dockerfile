FROM noonien/perforce-base
LABEL maintainer="George Jiglau <george@mux.ro>"

# Install the perforce server
RUN apt-get update && apt-get install -y helix-p4d=2018.2-1751184~bionic curl && \
    # clean temporary files
    rm -rf /var/log/* && \
    rm -rf /var/lib/apt/lists/*

# Volumes for server roots and triggers
VOLUME /opt/perforce/servers
VOLUME /opt/perforce/triggers

# Add startup file and run it by default
COPY run.sh /
CMD ["/run.sh"]
