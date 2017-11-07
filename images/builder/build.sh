#!/bin/bash -l

set -e

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

build::user::create $USER


log::m-info "Installing dependencies ..."
apt-get -qq update
apt-get install -yqq \
	build-essential \
	ca-certificates \
	curl \
	erlang \
	erlang-src \
	expat \
	git-core \
	htmldoc \
	libexpat1-dev \
	libssl-dev \
	libncurses5-dev \
	libxslt-dev \
	openssl \
	python \
    unzip \
    wget \
    zip \
    zlib1g-dev


log::m-info "Setting Ownership & Permissions ..."
chown -R $USER:$USER ~


# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"
