#
# Copyright 2016 Telefonica Investigación y Desarrollo, S.A.U
#
# This file is part of perseo-core
#
# perseo-core is free software: you can redistribute it and/or modify it under the terms of the GNU Affero
# General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
# perseo-core is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
# for more details.
#
# You should have received a copy of the GNU Affero General Public License along with perseo-core. If not, see
# http://www.gnu.org/licenses/.
#
# For those usages not covered by the GNU Affero General Public License please contact with iot_support at tid dot es
#

FROM tomcat:9
ARG GITHUB_ACCOUNT=telefonicaid
ARG GITHUB_REPOSITORY=perseo-core

# Install maven

WORKDIR /code

# Prepare by downloading dependencies
COPY pom.xml /code/pom.xml
COPY perseo-main /code/perseo-main/
COPY perseo-utils /code/perseo-utils/
COPY perseo_core-entrypoint.sh /code


# hadolint ignore=DL3005,DL3008