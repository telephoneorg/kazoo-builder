#!/bin/bash -l

set -e

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

build::user::create $USER

apt-get -q update


log::m-info "Installing essentials ..."
apt-get install -qq -y curl ca-certificates


log::m-info "Installing dependencies ..."
apt-get install -qq -y \
	build-essential \
	expat \
	git-core \
	htmldoc \
	libexpat1-dev \
	libssl-dev \
	libncurses5-dev \
	libxslt-dev \
	python \
    unzip \
    wget \
    zip \
    zlib1g-dev


log::m-info "Installing kerl ..."
curl -sSL -o /usr/bin/kerl \
	https://raw.githubusercontent.com/yrashk/kerl/master/kerl
chmod +x /usr/bin/kerl


log::m-info "Installing erlang $ERLANG_VERSION ..."
kerl build $ERLANG_VERSION r${ERLANG_VERSION}
kerl install $_ /usr/lib/erlang
. /usr/lib/erlang/activate


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
	git clone -b $KAZOO_CONFIGS_BRANCH --single-branch --depth 1 https://github.com/2600hz/kazoo-configs .
	find -mindepth 1 -maxdepth 1 -not -name system -not -name core -exec rm -rf {} \;
	mkdir -p ~/etc/kazoo/core
	mv core/* $_
	popd && rm -rf $OLDPWD



log::m-info "Installing nodejs v$NODE_VERSION ..."
curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
apt-get install -y nodejs


log::m-info "Installing node packages ..."
npm install -g npm gulp


log::m-info "Installing monster-ui ..."
cd /tmp
	git clone -b $MONSTER_APPS_BRANCH --single-branch --depth 1 https://github.com/2600hz/monster-ui monster-ui
	pushd $_
		log::m-info "Installing monster-ui apps ..."
		pushd src/apps
			for app in ${MONSTER_APPS//,/ }; do
				git clone -b $MONSTER_APPS_BRANCH --single-branch --depth 1 https://github.com/2600hz/monster-ui-${app} $app
			done
			popd
		npm install
		gulp build-prod
		pushd dist/apps
			git clone -b $MONSTER_APP_APIEXPLORER_BRANCH --single-branch --depth 1 https://github.com/siplabs/monster-ui-apiexplorer apiexplorer
			popd

			log::m-info "Cleaning up monster-ui apps ..."
			# we only need these files for the metadata that will be loaded when running init apps
			npm uninstall

			find dist/apps -mindepth 2 -maxdepth 2 -not -name i18n -not -name metadata -exec rm -rf {} \;
			find dist -mindepth 1 -maxdepth 1 -not -name apps -exec rm -rf {} \;
			find -mindepth 1 -maxdepth 1 -not -name dist -exec rm -rf {} \;

			mkdir -p ~/monster-ui
			mv dist/* $_
			popd && rm -rf $OLDPWD


log::m-info "Removing npm dirs in ~ ..."
rm -rf ~/.{npm,v8*} /tmp/npm*


log::m-info "Removing kerl ..."
rm -rf /usr/bin/kerl ~/.kerl*


log::m-info "Creating Directories ..."
mkdir -p ~/log


log::m-info "Setting Ownership & Permissions ..."
chown -R $USER:$USER ~


log::m-info "Cleaning up ..."
apt-clean --aggressive
find ~ -maxdepth 1 -type f -name '.*' -exec rm -f {} \;


log::m-info "Creating archive ..."
tar czvf /tmp/kazoo.tar.gz ~
mv /tmp/kazoo.tar.gz ~/


# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"
