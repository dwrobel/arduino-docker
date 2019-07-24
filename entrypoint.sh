#!/bin/bash -xe
#
# Copyright (C) 2018  Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

groupadd --non-unique --gid $GID "$USER" || test $? = 9
useradd --no-create-home -G wheel --uid $UID --gid $GID "$USER" || test $? = 9

gid=$(stat -c "%G" /dev/dri/card0 2>/dev/null || echo "")

if [ x${gid} != "x" ]; then
    usermod -a -G $gid $USER || true
fi

if [ -z ${XDG_RUNTIME_DIR} ]; then
    XDG_RUNTIME_DIR=/run/user/$UID
    mkdir -p ${XDG_RUNTIME_DIR}
    chown $UID:$UID ${XDG_RUNTIME_DIR}
    chmod 0700 ${XDG_RUNTIME_DIR}
    export XDG_RUNTIME_DIR
fi

usermod -a -G dialout,tty $USER || true

cd "$CWD"

preserved_envs="PATH,DISPLAY,WAYLAND_DISPLAY,XDG_RUNTIME_DIR,CC,CXX"

if [ -f /etc/profile.d/ccache.sh ] ; then

    if [ -w "$CACHE_DIR" ] && [ -d "$CACHE_DIR" ] ; then
        export CCACHE_DIR=$CACHE_DIR/ccache
        sudo -u "$USER" mkdir -p $CCACHE_DIR
        sudo -u "$USER" --preserve-env=CCACHE_DIR ccache --set-config=max_size=2G
        preserved_envs="$preserved_envs,CCACHE_DIR"
    fi

    sed -i 's/unset\ CCACHE_DIR/#unset\ CCACHE_DIR/g' \
           /etc/profile.d/ccache.sh

    source /etc/profile.d/ccache.sh

fi

sudo -H -u "$USER" --preserve-env=$preserved_envs "$@"
