# Kazoo 4.0 Builder

[![Build Status](https://travis-ci.org/sip-li/kazoo-builder.svg?branch=master)](https://travis-ci.org/sip-li/kazoo-builder) [![Docker Pulls](https://img.shields.io/docker/pulls/callforamerica/kazoo-builder.svg)](https://store.docker.com/community/images/callforamerica/kazoo-builder)

## Maintainer

Joe Black <joeblack949@gmail.com>

## Description

This is just a builder for kazoo 4.0.  See the docker-kazoo or kazoo repo.

## Build Environment

Build environment variables are often used in the build script to bump version numbers and set other options during the docker build phase.  Their values can be overridden using a build argument of the same name.

* `ERLANG_VERSION`: supplied to kerl to select the version of erlang that is installed prior to kazoo being built. Defaults to `18.3`.

* `KAZOO_VERSION`: Informational purposes. Defaults to `4.0`.

* `KAZOO_BRANCH`: supplied to `git clone -b` when cloning the kazoo repo. Defaults to `4.0`.

* `KAZOO_CONFIGS_BRANCH`: supplied to `git clone -b` when cloning the kazoo-configs repo. Defaults to `4.0`.

* `KAZOO_SOUNDS_BRANCH`: supplied to `git clone -b` when cloning the kazoo-sounds repo. Defaults to `4.0`.

* `MONSTER_UI_BRANCH`: supplied to `git clone -b` when cloning the monster-ui repo. Defaults to `4.0`.

* `MONSTER_APPS_VERSION`: Informational purposes. Defaults to `4.0`.

* `MONSTER_APPS`: a comma delimited list of monster apps to clone/install.  Defaults to `accounts,callflows,fax,numbers,pbxs,voip,voicemails,webhooks`.

* `MONSTER_APPS_BRANCH`: supplied to `git clone -b` when cloning the monster-ui application repos. Defaults to `master`.

* `MONSTER_APP_APIEXPLORER_BRANCH`: supplied to `git clone -b` when cloning the monster-ui-apiexplorer repo. Defaults to `master`.

* `NODE_VERSION`: used to select the version of node.js to install. Defaults to `6`.

* `KERL_CONFIGURE_OPTIONS`: Used by kerl when building erlang, Defaults to `--disable-hipe --without-odbc --without-javac`.

The following variables are standard in most of our dockerfiles to reduce duplication and make scripts reusable among different projects:

* `APP`: kazoo
* `USER`: kazoo
* `HOME` /opt/kazoo
