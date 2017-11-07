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


log::m-info "Installing kazoo ..."
cd /tmp
	git clone -b $KAZOO_BRANCH --single-branch --depth 1 https://github.com/2600Hz/kazoo kazoo
	pushd $_
		make
		make build-release
		make sup_completion
		pushd _rel/kazoo
			find -type d -exec mkdir -p ~/\{} \;
	        find -type f -exec mv \{} ~/\{} \;
			popd
		mv sup.bash ~/
		mv core/sup/sup ~/bin/
		mv {scripts,doc} ~/
		~/lib/sup-*/priv/build-autocomplete.escript ~/sup.bash ~ > ~/doc/sup_commands.txt
		popd && rm -rf $OLDPWD


log::m-info "Installing kazoo-sounds ..."
cd /tmp
	git clone -b $KAZOO_SOUNDS_BRANCH --single-branch --depth 1 https://github.com/2600hz/kazoo-sounds kazoo-sounds
	pushd $_
		mkdir -p ~/media/prompts
		mv kazoo-core/* $_
		popd && rm -rf $OLDPWD


log::m-info "Installing kazoo-configs ..."
mkdir -p /tmp/kazoo-configs
pushd $_
	git clone -b $KAZOO_CONFIGS_BRANCH --single-branch --depth 1 https://github.com/2600hz/kazoo-configs-core .
	mkdir -p ~/etc/kazoo/
	mv core ~/etc/kazoo/
	popd && rm -rf $OLDPWD


log::m-info "Setting Ownership & Permissions ..."
chown -R $USER:$USER ~


log::m-info "Cleaning up ..."
find ~ -maxdepth 1 -type f -name '.*' -exec rm -f {} \;


# log::m-info "Creating archive ..."
# tar czvf /tmp/kazoo.v${KAZOO_BRANCH}.tar.gz ~
# mv /tmp/kazoo.v${KAZOO_BRANCH}.tar.gz ~/


# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"
