# Copyright (C) 2021 CGI France
#
# This file is part of LINO.
#
# LINO is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# LINO is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with LINO.  If not, see <http:#www.gnu.org/licenses/>.

FROM cgifr/pimo:v1.8.0 AS pimo

FROM ghcr.io/oracle/oraclelinux7-instantclient:19

RUN yum -y install less jq wget git && \
    rm -rf /var/cache/yum


ARG VERSION_MILLER=5.10.2
ADD https://github.com/johnkerl/miller/releases/download/v${VERSION_MILLER}/mlr.linux.x86_64 /usr/bin/mlr
RUN chmod +x /usr/bin/mlr

COPY bin/lino /usr/bin/lino

COPY --from=pimo /usr/bin/pimo /usr/bin/pimo

WORKDIR /home/lino

CMD ["bash"]

ARG BUILD_DATE
ARG VERSION
ARG REVISION

# https://github.com/opencontainers/image-spec/blob/master/annotations.md