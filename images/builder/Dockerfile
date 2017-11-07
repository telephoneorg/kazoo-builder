FROM telephoneorg/debian:stretch

MAINTAINER Joe Black <me@joeblack.nyc>

ARG     KAZOO_BRANCH
ARG     KAZOO_CONFIGS_BRANCH
ARG     KAZOO_SOUNDS_BRANCH

ENV     KAZOO_BRANCH ${KAZOO_BRANCH:-4.1.39}
ENV     KAZOO_CONFIGS_BRANCH ${KAZOO_CONFIGS_BRANCH:-4.1.21}
ENV     KAZOO_SOUNDS_BRANCH ${KAZOO_SOUNDS_BRANCH:-4.1.0}

LABEL   app.kazoo.core.branch=$KAZOO_BRANCH
LABEL   app.kazoo.configs.branch=$KAZOO_CONFIGS_BRANCH
LABEL   app.kazoo.sounds.branch=$KAZOO_SOUNDS_BRANCH

ENV     APP kazoo
ENV     USER $APP
ENV     HOME /opt/$APP

COPY    build.sh /tmp/
RUN     /tmp/build.sh

COPY    build-kazoo.sh /

WORKDIR $HOME

CMD     ["/build-kazoo.sh"]

# RUN lib/sup-*/priv/build-autocomplete.escript sup.bash . > doc/sup_commands.txt
