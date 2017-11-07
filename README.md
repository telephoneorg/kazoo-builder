# Kazoo 4.x Builder
[![Build Status](https://travis-ci.org/telephoneorg/kazoo-builder.svg?branch=master)](https://travis-ci.org/telephoneorg/kazoo-builder)


## Maintainer
Joe Black <me@joeblack.nyc>


## Description
This is just a builder for kazoo 4.x, which is used in [docker-kazoo](https://github.com/telephoneorg/docker-kazoo).


## Build Environment
Build environment variables are often used in the build script to bump version numbers and set other options during the docker build phase.  Their values can be overridden using a build argument of the same name.

* `KAZOO_VERSION`: Informational purposes. Defaults to `4.2`.
* `KAZOO_BRANCH`: supplied to `git clone -b` when cloning the kazoo repo. Defaults to `$KAZOO_VERSION`.
* `KAZOO_CONFIGS_BRANCH`: supplied to `git clone -b` when cloning the kazoo-configs repo. Defaults to `$KAZOO_BRANCH`.
* `KAZOO_SOUNDS_BRANCH`: supplied to `git clone -b` when cloning the kazoo-sounds repo. Defaults to `$KAZOO_BRANCH`.

The following variables are standard in most of our dockerfiles to reduce duplication and make scripts reusable among different projects:

* `APP`: kazoo
* `USER`: kazoo
* `HOME` /opt/kazoo
