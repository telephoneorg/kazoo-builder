# Kazoo 4.x Builder
[![Build Status](https://travis-ci.org/telephoneorg/kazoo-builder.svg?branch=master)](https://travis-ci.org/telephoneorg/kazoo-builder) [![Deb packages](https://img.shields.io/bintray/v/telephoneorg/kazoo-builder/kazoo.svg)](https://bintray.com/telephoneorg/kazoo-builder/kazoo)


## Maintainer
Joe Black <me@joeblack.nyc> | [github](https://www.github.com/joeblackwaslike)


## Description
This is just a builder for kazoo 4.x, which is used in [docker-kazoo](https://github.com/telephoneorg/docker-kazoo).  This image clones the kazoo git repo, applies all patches in [patches](images/builder/patches), builds kazoo from source, packages it as a debian deb package, then uploads it to our debian repo.  It also builds seperate packages for the config files and the sound files.


Debian packages built:
* kazoo
* kazoo-configs
* kazoo-sounds


## Build Environment
Build environment variables are often used in the [build-kazoo.sh](images/builder/build-kazoo.sh) script to bump version numbers and set other options during the docker build phase.  Their values can be overridden using a build argument of the same name.
* `KAZOO_VERSION`
* `KAZOO_CONFIGS_VERSION`
* `KAZOO_SOUNDS_VERSION`

The following variables are standard in most of our dockerfiles to reduce duplication and make scripts reusable among different projects:
* `APP`: kazoo
* `USER`: kazoo
* `HOME` /opt/kazoo


## Installing kazoo
```bash
gpg --recv-key 04DFE96608062553B3701F2E7CA7320BE23F8CA8
echo "deb https://dl.bintray.com/telephoneorg/kazoo-builder stretch main" > /etc/apt/sources.list.d/telephone-org.list
apt-get update

apt-get install -y \
    kazoo \
    kazoo-configs \
    kazoo-sounds
```
