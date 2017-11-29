# Kazoo 4.x Builder
[![Build Status](https://travis-ci.org/telephoneorg/kazoo-builder.svg?branch=master)](https://travis-ci.org/telephoneorg/kazoo-builder) [![Deb packages](https://img.shields.io/bintray/v/telephoneorg/kazoo-builder/kazoo.svg)](https://travis-ci.org/telephoneorg/kazoo-builder)



## Maintainer
Joe Black <me@joeblack.nyc> | [github](https://www.github.com/joeblackwaslike)


## Description
This is just a builder for kazoo 4.x, which is used in [docker-kazoo](https://github.com/telephoneorg/docker-kazoo).


## Build Environment
Build environment variables are often used in the [build-kazoo.sh](images/builder/build-kazoo.sh) script to bump version numbers and set other options during the docker build phase.  Their values can be overridden using a build argument of the same name.
* `KAZOO_VERSION`
* `KAZOO_CONFIGS_VERSION`
* `KAZOO_SOUNDS_VERSION`

The following variables are standard in most of our dockerfiles to reduce duplication and make scripts reusable among different projects:
* `APP`: kazoo
* `USER`: kazoo
* `HOME` /opt/kazoo
