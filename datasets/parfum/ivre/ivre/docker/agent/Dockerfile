# This file is part of IVRE.
# Copyright 2011 - 2021 Pierre LALET <pierre@droids-corp.org>
#
# IVRE is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# IVRE is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
# License for more details.
#
# You should have received a copy of the GNU General Public License
# along with IVRE. If not, see <http://www.gnu.org/licenses/>.

ARG TAG=latest
FROM ivre/client:${TAG}
LABEL maintainer="Pierre LALET <pierre@droids-corp.org>"

RUN ivre runscans --output Agent > /usr/bin/agent && \
    chmod +x /usr/bin/agent

VOLUME /var/lib/ivre-agent
WORKDIR /var/lib/ivre-agent
CMD exec /usr/bin/agent
