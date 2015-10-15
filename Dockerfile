FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
COPY install-go.sh /tmp/install-go.sh
RUN /tmp/install-go.sh
#RUN wget -qO- https://experimental.docker.com/ | sh
#COPY install-docker-tools.sh /tmp/install-docker-tools.sh
#RUN /tmp/install-docker-tools.sh
#RUN rm -rf /usr/src/go
RUN rm -rf /usr/src/go1.4.2.src.tar.gz

