FROM telephoneorg/debian:stretch

MAINTAINER Joe Black <me@joeblack.nyc>

ENV     APP kazoo
ENV     USER $APP
ENV     HOME /opt/$APP

COPY    build.sh /tmp/
RUN     /tmp/build.sh

ENV     KAZOO_VERSION=${KAZOO_VERSION:-4.1.39}
ENV     KAZOO_CONFIGS_VERSION=${KAZOO_CONFIGS_VERSION:-4.1.21}
ENV     KAZOO_SOUNDS_VERSION=${KAZOO_SOUNDS_VERSION:-4.1.0}

LABEL   app.kazoo.configs.version=$KAZOO_CONFIGS_VERSION
LABEL   app.kazoo.sounds.version=$KAZOO_SOUNDS_VERSION
LABEL   app.kazoo.core.version=$KAZOO_VERSION

COPY    build-kazoo.sh /

WORKDIR $HOME

CMD     ["/build-kazoo.sh"]
