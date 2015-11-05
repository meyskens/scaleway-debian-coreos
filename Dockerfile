## -*- docker-image-name: "scaleway/ubuntu-coreos:latest" -*-
FROM scaleway/docker:1.9.0
MAINTAINER Maarten Eyskens <maarten@innovatete.ch> (@meyskens)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update                   \
 && apt-get --force-yes -y -qq upgrade  \
 && apt-get --force-yes install -y -q build-essential \
 && apt-get clean


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
ADD ./patches/usr/local/ /usr/local/
RUN cd /usr/local/update-firewall && \
    GOPATH=/usr/src/spouse GOBIN=$GOPATH/bin go get

# Patch rootfs
ADD ./patches/etc/ /etc/
RUN systemctl disable docker; systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
