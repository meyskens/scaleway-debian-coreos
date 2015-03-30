## -*- docker-image-name: "armbuild/ocs-app-docker:latest" -*-
FROM armbuild/ocs-distrib-ubuntu:utopic
MAINTAINER Online Labs <opensource@ocs.online.net> (@online_en)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update &&                   \
    apt-get --force-yes -y -qq upgrade &&  \
    apt-get --force-yes install -y -q      \
        bridge-utils                       \
        python-setuptools                  \
    && apt-get clean


# Install Docker dependencies
RUN apt-get install $(apt-cache depends docker.io | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')


# Install Docker 1.5
RUN wget -q https://get.docker.io/builds/Linux/armel/docker-1.5.0 -O /usr/bin/docker \
 && wget -q https://raw.githubusercontent.com/docker/docker/v1.5.0/contrib/init/upstart/docker.conf -O /etc/init/docker.conf \
 && wget -q https://raw.githubusercontent.com/docker/docker/v1.5.0/contrib/init/sysvinit-debian/docker -O /etc/init.d/docker \
 && chmod +x /usr/bin/docker /etc/init.d/docker \
 && addgroup docker \
 && update-rc.d -f docker defaults
 
 
# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework


# Install Gosu
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.2/gosu-armhf && \
    chmod +x /usr/local/bin/gosu


# Install Docker Compose and fig
RUN easy_install -U pip \
 && pip install docker-compose \
 && pip install fig


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/bin/ /usr/bin/
ADD ./patches/usr/local/ /usr/local/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave