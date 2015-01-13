DOCKER_NAMESPACE =	armbuild/
NAME =			ocs-app-docker
VERSION =		latest
VERSION_ALIASES =	15.04 15 vivid
TITLE =			Docker 1.3.2
DESCRIPTION =		Docker 1.3.2 + fig + gosu + nsenter + pipework
SOURCE_URL =		https://github.com/online-labs/image-app-docker


## Image tools  (https://github.com/online-labs/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/image-tools | bash
-include docker-rules.mk
## Here you can add custom commands and overrides


update_fig:
	docker run --rm armbuild/docker-fig bash -c 'cat /code/dist/fig-*-py2.7.egg' > sources/fig.egg


update_nsenter:
	docker run --rm -v $(PWD)/patches/usr/bin:/target armbuild/jpetazzo-nsenter

update_swarm:
	go get -u github.com/docker/swarm
	cd $(GOPATH)/src/github.com/docker/swarm/ && GOOS=linux GOARCH=arm GOARM=7 go build -a -v -ldflags '-d -w -s' -o $(PWD)/patches/usr/bin/swarm
