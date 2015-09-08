DOCKER_NAMESPACE =	meyskens/
NAME =			scw-app-ubuntu-coreos
VERSION =		latest
VERSION_ALIASES =	1.0
TITLE =			CoreOS-like ARM Ubuntu image
DESCRIPTION =		Docker + Fleet + Etcd
SOURCE_URL =		https://github.com/meyskens/scw-app-ubuntu-coreos


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
## Here you can add custom commands and overrides


update_nsenter:
	docker run --rm -v $(PWD)/patches/usr/bin:/target armbuild/jpetazzo-nsenter

update_swarm:
	go get -u github.com/docker/swarm
	cd $(GOPATH)/src/github.com/docker/swarm/ && GOOS=linux GOARCH=arm GOARM=7 go build -a -v -ldflags '-d -w -s' -o $(PWD)/patches/usr/bin/swarm
