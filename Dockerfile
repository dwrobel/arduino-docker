#
# Copyright (C) 2018 Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
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

FROM fedora:34

LABEL maintainer="dwrobel@ertelnet.rybnik.pl" description="Base OCI image for building Arduino projects"

RUN dnf install -y make arduino-builder arduino-core arduino-devel avrdude ccache clang git-core mr picocom sudo maven

RUN echo >/etc/sudoers.d/wheel-no-passwd '%wheel	ALL=(ALL)	NOPASSWD: ALL'

RUN dnf update -y

RUN dnf clean all

ADD entrypoint.sh /
