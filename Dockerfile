## -*- docker-image-name: "scaleway/ubuntu-coreos:latest" -*-
FROM meyskens/docker-debian:amd64-latest
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM meyskens/docker-debian:armhf-latest	# arch=armv7l
#FROM meyskens/docker-debian:arm64-latest	# arch=arm64
#FROM meyskens/docker-debian:i386-latest		# arch=i386
#FROM meyskens/docker-debian:mips-latest		# arch=mips
MAINTAINER Maartje Eyskens <maartje@innovatete.ch> (@meyskens)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update                   \
 && apt-get --force-yes -y -qq upgrade  \
 && apt-get --force-yes install -y -q build-essential tar \
 && apt-get clean


# Install Go
RUN apt-get -y -t jessie-backports install golang-go  && \
    echo "export GOPATH=/usr/src/spouse" >> ~/.bashrc && \
    mkdir /usr/src/spouse

# Install Fleet
RUN cd /usr/src/ && \
    GOPATH=/usr/src/spouse go get golang.org/x/tools/cmd/cover && \
    git clone https://github.com/coreos/fleet.git -b v0.13.0 && cd fleet && \
    ./build && \
    ln -s /usr/src/fleet/bin/* /usr/bin/

# Install Etcd
RUN cd /usr/src/ && git clone https://github.com/coreos/etcd.git -b release-2.3 && \
    cd /usr/src/etcd && \
    ./build && \
    ln -s /usr/src/etcd/bin/* /usr/bin/ && \
    mkdir /var/lib/etcd

# Install Flannel
RUN cd /usr/src/ && git clone https://github.com/coreos/flannel.git && \
    cd /usr/src/flannel && git checkout v0.6.2 && \
    make dist/flanneld && \
    ln -s /usr/src/flannel/bin/* /usr/bin/ && \

# Installing UFW
RUN apt-get -y install ufw && \
    ufw default allow incoming

COPY ./overlay/ /

RUN systemctl disable docker; systemctl enable docker

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
