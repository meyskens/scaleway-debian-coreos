## -*- docker-image-name: "scaleway/ubuntu-coreos:latest" -*-
FROM scaleway/ubuntu:vivid
MAINTAINER Maarten Eyskens <maarten@innovatete.ch> (@meyskens)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update                   \
 && apt-get --force-yes -y -qq upgrade  \
 && apt-get --force-yes install -y -q apparmor arping aufs-tools btrfs-tools bridge-utils cgroup-lite git ifupdown kmod lxc python-setuptools vlan build-essential \
 && apt-get clean


# Install Docker dependencies
RUN apt-get install $(apt-cache depends docker.io | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')


# Install Docker
ENV DOCKER_VERSION 1.8.1
ENV DOCKER_FIX -1
# docker-hypriot_XXX_armhf.deb built using https://github.com/hypriot/rpi-docker-builder
RUN wget -q http://downloads.hypriot.com/docker-hypriot_${DOCKER_VERSION}${DOCKER_FIX}_armhf.deb -O /tmp/docker.deb \
 && dpkg -i /tmp/docker.deb \
 && rm -f /tmp/docker.deb \
 && systemctl enable docker
 
 
# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework


# Install Gosu
ENV GOSU_VERSION 1.3
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf && \
    chmod +x /usr/local/bin/gosu


# Install Docker Compose
RUN easy_install -U pip \
 && pip install docker-compose \
 && ln -s /usr/local/bin/docker-compose /usr/local/bin/fig


# Install Docker Machine
ENV DOCKER_MACHINE_VERSION 0.3.1
RUN wget -qO /usr/local/bin/docker-machine https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine_linux-arm \
 && chmod +x /usr/local/bin/docker-machine


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/bin/ /usr/bin/
ADD ./patches/usr/local/ /usr/local/
RUN systemctl disable docker; systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave

# Install Go
RUN cd /usr/src/ && \
    git clone https://go.googlesource.com/go && \
    cd go && git checkout go1.4.2 && \
    cd src && ./make.bash && \
    ln -s /usr/src/go/bin/* /usr/bin/  && \
    echo "export GOPATH=/usr/src/spouse" >> ~/.bashrc && \
    mkdir /usr/src/spouse
    
# Install Fleet
RUN cd /usr/src/ && \
    GOPATH=/usr/src/spouse go get golang.org/x/tools/cmd/cover && \
    git clone https://github.com/coreos/fleet.git && cd fleet && \
    ./build && \
    ln -s /usr/src/fleet/bin/* /usr/bin/
 
# Install Etcd    
RUN cd /usr/src/ && git clone https://github.com/coreos/etcd.git -b release-2.2 && \
    cd /usr/src/etcd && \
    ./build && \
    ln -s /usr/src/etcd/bin/* /usr/bin/ && \
    mkdir /var/lib/etcd 

# Install flannel
RUN cd /usr/src && \
    git clone https://github.com/coreos/flannel.git && \
    cd flannel && ./build && \
    ln -s /usr/src/flannel/bin/* /usr/bin/
    
# Installing UFW
RUN apt-get -y install ufw && \
    sed -i "s/IPV6=yes/IPV6=no/g" /etc/default/ufw && \
    ufw default allow incoming
    
# Installing update-firewall
RUN cd /usr/local/update-firewall && \
    GOPATH=/usr/src/spouse GOBIN=$GOPATH/bin go get
