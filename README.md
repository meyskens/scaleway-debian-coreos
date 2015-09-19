# Ubuntu-with-CoreOS-tools image for Scaleway


Scripts to build a Ubuntu image on Scaleway with the common used tools of CoreOS like fleet, etcd and flanneld (soon more to be added).

This image is built using [Image Tools](https://github.com/scaleway/image-tools) and depends on the official [Docker](https://github.com/scaleway/image-docker) image.

---

**This image is meant to be used on a C1 server.**

We use the Docker's building system and convert it at the end to a disk image that will boot on real servers without Docker. Note that the image is still runnable as a Docker container for debug or for inheritance, but really running Docker inside Docker?.

[More info](https://github.com/scaleway/image-tools#docker-based-builder)

---

## Install

Build and write the image to /dev/nbd1 (see [documentation](https://www.scaleway.com/docs/create_an_image_with_docker))

```console
$ make install
```

Full list of commands available at: [scaleway/image-tools](https://github.com/scaleway/image-tools/tree/master/scripts#commands)

---

## How to use

To set up a cluster you need at least 3 nodes, this is required for etcd to work. Setting up these nodes is quite simple.

1. Go create a new server and select this image.
2. If you start a new cluster you need an etcd discovery link as start point. You can get one at https://discovery.etcd.io/new
3. Add your discover link as a tag to your server in format `discover:https://discovery.etcd.io/secretkeyyougot`. Make sure it is the first tag!
4. Set a second tag with your Scaleway access key and token in format `api:accesskey:token`. 
5. Repeat this at least 2 more times.
6. Enjoy! You can just login as root and use fleet to manage your unit files.

---

## Links

- [Community: Docker Support](https://community.cloud.online.net/t/official-docker-support/374?u=manfred)
- [Community: Getting started with Docker on C1 (armhf)](https://community.cloud.online.net/t/getting-started-docker-on-c1-armhf/383?u=manfred)
- [Online Labs Blog - Docker on C1](https://blog.cloud.online.net/2014/10/27/docker-on-c1/)

---


## Q&A

**Why not Gentoo?** *The main reason is that I don't have much experience with Gentoo to make a propper working image in a short time.*

**Why not port the CoreOS source?** *CoreOS doesn't seem to show interest in other architectures. Some dependencies even give a warning on compile time. Another argument is that their update system also manages the kernel and Scaleway does not support using your own kernel.*

**Why do you want my API keys?** *We use this to discover other nodes on your account and giving only those IPs access to sensitive ports as etcd.*

**Why do I need 3 servers?** *Becuase everything (including Docker) is dependend on etcd. Etcd needs at least 3 nodes by default. You can work this arround but if you need less than 3 you should reconsider if you need this.*

---

A project by [Innovate Technologies](https://github.com/Innovate-Technologies/)
