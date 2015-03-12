## -*- docker-image-name: "armbuild/ocs-app-docker:vivid" -*-
FROM armbuild/ocs-distrib-ubuntu:vivid
MAINTAINER Online Labs <opensource@ocs.online.net> (@online_en)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update &&                   \
    apt-get --force-yes -y -qq upgrade &&  \
    apt-get --force-yes install -y -q      \
        bridge-utils                       \
        fig                                \
        python-setuptools                  \
    && apt-get clean


# Install Docker dependencies
RUN apt-get install $(apt-cache depends docker.io | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')


# Install Docker 1.5
RUN wget http://ftp.fr.debian.org/debian/pool/main/d/docker.io/docker.io_1.5.0~dfsg1-1_armhf.deb -O /tmp/docker.deb \
 && dpkg -i /tmp/docker.deb \
 && rm -f /tmp/docker.deb


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework


# Install Gosu
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.2/gosu-armhf && \
    chmod +x /usr/local/bin/gosu


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/bin/ /usr/bin/
ADD ./patches/usr/local/ /usr/local/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
