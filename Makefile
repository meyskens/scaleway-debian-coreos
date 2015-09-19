NAME =			ubuntu-coreos
VERSION =		latest
VERSION_ALIASES =	1.0
TITLE =			CoreOS-like image based on Ubuntu
DESCRIPTION =		Docker + Fleet + Etcd + Flannel
SOURCE_URL =		https://github.com/scaleway/ubuntu-coreos
VENDOR_URL =		https://www.docker.com

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	docker
IMAGE_NAME =		CoreOS-like image based on Ubuntu


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
