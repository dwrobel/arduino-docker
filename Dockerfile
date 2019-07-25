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

FROM fedora:30
RUN dnf install -y dnf-plugins-core
RUN dnf copr enable -y dwrobel/avr-gcc

LABEL maintainer="dwrobel@ertelnet.rybnik.pl" description="Base Docker image for building Arduino projects"

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN dnf install -y make arduino-builder arduino-core avrdude ccache clang git-core mr picocom sudo

RUN echo >/etc/sudoers.d/wheel-no-passwd '%wheel	ALL=(ALL)	NOPASSWD: ALL'

RUN dnf update -y

RUN dnf clean all
