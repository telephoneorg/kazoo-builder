#!/bin/bash -l

KAZOO_SHORT_VERSION=${KAZOO_VERSION%.*}

set -e


env

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

log::m-info "Packaging time!"
mkdir -p /tmp/kazoo
pushd $_
    log::m-info "Compiling kazoo v$KAZOO_VERSION ..."
	git clone -b $KAZOO_VERSION --single-branch --depth 1 https://github.com/2600Hz/kazoo kazoo
    pushd $_
        log::m-info "Applying patches ..."
        mv /tmp/patches .
        git apply patches/*.diff

		make
		make build-release
		make sup_completion

		mv core/sup/sup _rel/kazoo/bin/
		mv sup.bash _rel/kazoo
        chmod +x _rel/kazoo/bin/{nodetool,install_upgrade.escript}

		mv {scripts,doc} _rel/kazoo
		_rel/kazoo/lib/sup-*/priv/build-autocomplete.escript _rel/kazoo/sup.bash _rel/kazoo > _rel/kazoo/doc/sup_commands.txt
        popd

    mkdir -p kazoo_$KAZOO_VERSION/{opt,DEBIAN} kazoo_$KAZOO_VERSION/etc/security/limits.d kazoo_$KAZOO_VERSION/usr/bin kazoo_$KAZOO_VERSION/etc/bash_completion.d
    mv kazoo/_rel/kazoo kazoo_$KAZOO_VERSION/opt
    pushd kazoo_$KAZOO_VERSION
        mv opt/kazoo/bin/sup usr/bin
        mv opt/kazoo/sup.bash /etc/bash_completion.d
        curl -o etc/security/limits.d/kazoo.limits.conf \
            https://raw.githubusercontent.com/2600hz/kazoo-configs-core/$KAZOO_SHORT_VERSION/system/security/limits.d/kazoo-core.limits.conf
        tee DEBIAN/control <<EOF
Package: kazoo
Version: $KAZOO_VERSION
Architecture: amd64
Depends: expat (>= 2.0.0), libexpat1-dev (>= 2.0.0), htmldoc (>= 1.8.0), iputils-ping (>= 3.0), libncurses5-dev (>= 6.0), libssl1.0.2 (>= 1.0.2), libssl-dev (>= 1.1.0), libxslt1-dev (>= 1.1.29-2.1), openssl (>= 1.1.0), zlib1g-dev (>= 1.2.8)
Maintainer: Joe Black <me@joeblack.nyc>
Description: The Cloud PBX solution for telecom.

EOF

		tee DEBIAN/postinst <<'EOF'
#!/bin/sh

set -e

case "$1" in
configure)
	! getent passwd kazoo > /dev/null 2&>1 && adduser --system --no-create-home --gecos "Kazoo" --group kazoo || true

    chown -R kazoo: /opt/kazoo /var/run/kazoo

	;;
esac

exit 0
EOF
        chmod 0755 DEBIAN/postinst
        cd ..

        dpkg-deb --build kazoo_$KAZOO_VERSION

        mv *.deb /dist
        popd && popd


log::m-info "Packaging kazoo-sounds ..."
mkdir -p /tmp/kazoo-sounds_$KAZOO_SOUNDS_VERSION
pushd $_
	git clone -b $KAZOO_SOUNDS_VERSION --single-branch --depth 1 https://github.com/2600hz/kazoo-sounds kazoo-sounds

    mkdir -p opt/kazoo/media/prompts
    mv kazoo-sounds/kazoo-core/* opt/kazoo/media/prompts
    rm -rf kazoo-sounds

    mkdir DEBIAN

    tee DEBIAN/control <<EOF
Package: kazoo-sounds
Version: $KAZOO_SOUNDS_VERSION
Architecture: amd64
Maintainer: Joe Black <me@joeblack.nyc>
Description: The Cloud PBX solution for telecom.
 Core sounds for kazoo prompts.

EOF

    tee DEBIAN/postinst <<'EOF'
#!/bin/sh

set -e

case "$1" in
    configure)
        ! getent passwd kazoo > /dev/null 2&>1 && adduser --system --no-create-home --gecos "Kazoo" --group kazoo || true
        chown -R kazoo: /opt/kazoo/media/prompts
        ;;
esac

exit 0
EOF
    chmod 0755 DEBIAN/postinst

    cd ..
    dpkg-deb --build kazoo-sounds_$KAZOO_SOUNDS_VERSION
    mv *.deb /dist
    popd


log::m-info "Packaging kazoo-configs ..."
mkdir -p /tmp/kazoo-configs_$KAZOO_CONFIGS_VERSION
pushd $_
    mkdir -p etc/kazoo
	git clone -b $KAZOO_CONFIGS_VERSION --single-branch --depth 1 https://github.com/2600hz/kazoo-configs-core

    mv kazoo-configs-core/core etc/kazoo
	rm -rf kazoo-configs-core

    mkdir DEBIAN

    tee DEBIAN/control <<EOF
Package: kazoo-core-configs
Version: $KAZOO_CONFIGS_VERSION
Architecture: amd64
Depends: kazoo (>= $KAZOO_VERSION)
Maintainer: Joe Black <me@joeblack.nyc>
Description: The Cloud PBX solution for telecom.
 Core configuration files for Kazoo.

EOF

    tee DEBIAN/postinst <<'EOF'
#!/bin/sh

set -e

case "$1" in
    configure)
        ! getent passwd kazoo > /dev/null 2&>1 && adduser --system --no-create-home --gecos "Kazoo" --group kazoo || true
        chown -R kazoo: /etc/kazoo/core
        ;;
esac

exit 0
EOF

    chmod 0755 DEBIAN/postinst

    cd ..
    dpkg-deb --build kazoo-configs_$KAZOO_CONFIGS_VERSION
    mv *.deb /dist
    popd


log::m-info "Creating archive ..."
cd /dist
    tar czvf /tmp/kazoo.v${KAZOO_VERSION}.tar.gz *
    mv /tmp/kazoo.v${KAZOO_VERSION}.tar.gz .

log::m-info "DONE! ..."

# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"
