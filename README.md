Docker image on Scaleway
========================

[![Run on Scaleway](http://scaleway.github.io/image-tools/assets/run.svg)](https://cloud.scaleway.com/#/servers/new?image=47820ea9-700f-40f8-8a28-d318a0fb7562)


Scripts to build the official Docker image on Scaleway

This image is built using [Image Tools](https://github.com/scaleway/image-tools) and depends on the official [Ubuntu](https://github.com/scaleway/image-ubuntu) image.

---

**This image is meant to be used on a C1 server.**

We use the Docker's building system and convert it at the end to a disk image that will boot on real servers without Docker. Note that the image is still runnable as a Docker container for debug or for inheritance.

[More info](https://github.com/scaleway/image-tools#docker-based-builder)

---

Install
-------

Build and write the image to /dev/nbd1 (see [documentation](https://www.scaleway.com/docs/create_an_image_with_docker))

    $ make install

Full list of commands available at: [scaleway/image-tools](https://github.com/scaleway/image-tools/tree/master/scripts#commands)

---

Links
-----

- [Community: Docker Support](https://community.cloud.online.net/t/official-docker-support/374?u=manfred)
- [Community: Getting started with Docker on C1 (armhf)](https://community.cloud.online.net/t/getting-started-docker-on-c1-armhf/383?u=manfred)
- [Online Labs Blog - Docker on C1](https://blog.cloud.online.net/2014/10/27/docker-on-c1/)

---

A project by [![Scaleway](https://avatars1.githubusercontent.com/u/5185491?v=3&s=42)](https://www.scaleway.com/)
