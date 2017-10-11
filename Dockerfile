FROM telephoneorg/debian:stretch

MAINTAINER Joe Black <me@joeblack.nyc>

ARG     KAZOO_BRANCH
ARG     KAZOO_CONFIGS_BRANCH
ARG     KAZOO_SOUNDS_BRANCH
ARG     MONSTER_UI_BRANCH
ARG     MONSTER_APPS
ARG     MONSTER_APPS_BRANCH
ARG     MONSTER_APP_APIEXPLORER_BRANCH
ARG     NODE_VERSION

ENV     KAZOO_BRANCH ${KAZOO_BRANCH:-4.2}
ENV     KAZOO_CONFIGS_BRANCH ${KAZOO_CONFIGS_BRANCH:-$KAZOO_BRANCH}
ENV     KAZOO_SOUNDS_BRANCH ${KAZOO_SOUNDS_BRANCH:-$KAZOO_BRANCH}
ENV     MONSTER_UI_BRANCH ${MONSTER_UI_BRANCH:-$KAZOO_BRANCH}
ENV     MONSTER_APPS ${MONSTER_APPS:-accounts,callflows,fax,numbers,pbxs,voip,voicemails,webhooks}
ENV     MONSTER_APPS_BRANCH ${MONSTER_APPS_BRANCH:-$MONSTER_UI_BRANCH}
ENV     MONSTER_APP_APIEXPLORER_BRANCH ${MONSTER_APP_APIEXPLORER_BRANCH:-master}
ENV     NODE_VERSION ${NODE_VERSION:-6}

LABEL   app.kazoo.core.branch=$KAZOO_BRANCH
LABEL   app.kazoo.configs.branch=$KAZOO_CONFIGS_BRANCH
LABEL   app.kazoo.sounds.branch=$KAZOO_SOUNDS_BRANCH
LABEL   app.kazoo.monster-ui.core.branch=$MONSTER_UI_BRANCH
LABEL   app.kazoo.monster-ui.apps.branch=$MONSTER_APPS_BRANCH
LABEL   app.kazoo.monster-ui.apps.list="${MONSTER_APPS},apiexplorer"

ENV     APP kazoo
ENV     USER $APP
ENV     HOME /opt/$APP

COPY    build.sh /tmp/
RUN     /tmp/build.sh

WORKDIR $HOME

RUN lib/sup-*/priv/build-autocomplete.escript sup.bash . > doc/sup_commands.txt
