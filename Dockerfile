# The Base Image used to create this Image

ARG APACHE_VERSION=latest

FROM ubuntu/apache2:${APACHE_VERSION}

RUN apt-get update && \
    apt-get install -y libapache2-mod-auth-openidc curl ca-certificates iputils-ping &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod auth_openidc rewrite ssl headers proxy_http proxy_wstunnel proxy_balancer remoteip http2


HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl --fail http://localhost:80/ || exit 1

