## -*- docker-image-name: "armbuild/scw-app-docker:latest" -*-
FROM armbuild/scw-distrib-ubuntu:vivid
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update                   \
 && apt-get --force-yes -y -qq upgrade  \
 && apt-get --force-yes install -y -q   \
        bridge-utils                    \
	kmod				\
        python-setuptools               \
 && apt-get clean


# Install Docker dependencies
RUN apt-get install $(apt-cache depends docker.io | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')


# Install Docker
ENV DOCKER_VERSION 1.7.0
RUN wget -q http://armbuild.fr-1.storage.online.net/docker-${DOCKER_VERSION} -O /usr/bin/docker \
 && wget -q https://raw.githubusercontent.com/docker/docker/v${DOCKER_VERSION}/contrib/init/systemd/docker.service -O /etc/systemd/system/docker.service \
 && wget -q https://raw.githubusercontent.com/docker/docker/v${DOCKER_VERSION}/contrib/init/systemd/docker.socket -O /etc/systemd/system/docker.socket \
 && chmod +x /usr/bin/docker \
 && addgroup docker \
 && systemctl enable docker
 
 
# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework


# Install Gosu
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.3/gosu-armhf && \
    chmod +x /usr/local/bin/gosu


# Install Docker Compose
RUN easy_install -U pip \
 && pip install docker-compose \
 && ln -s /usr/local/bin/docker-compose /usr/local/bin/fig


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/bin/ /usr/bin/
ADD ./patches/usr/local/ /usr/local/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
