# Copyright 2015 Telefónica Investigación y Desarrollo, S.A.U
#
# This file is part of the IoT Agent for the Ultralight 2.0 protocol (PEP) component
#
# PEP is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# PEP is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with PEP.
# If not, see http://www.gnu.org/licenses/.
#
# For those usages not covered by the GNU Affero General Public License
# please contact with: [sc_support at telefonica dot com]

ARG NODE_VERSION=16-slim
FROM node:${NODE_VERSION}
ARG GITHUB_ACCOUNT=telefonicaid
ARG GITHUB_REPOSITORY=fiware-pep-steelskin
ARG DOWNLOAD=latest
ARG SOURCE_BRANCH=master

# Copying Build time arguments to environment variables so they are persisted at run time and can be 
# inspected within a running container.
# see: https://vsupalov.com/docker-build-time-env-values/  for a deeper explanation.

ENV GITHUB_ACCOUNT=${GITHUB_ACCOUNT}
ENV GITHUB_REPOSITORY=${GITHUB_REPOSITORY}
ENV DOWNLOAD=${DOWNLOAD}

#
# The following RUN command retrieves the source code from GitHub.
# 
# To obtain the latest stable release run this Docker file with the parameters
# --no-cache --build-arg DOWNLOAD=stable
# To obtain any speciifc version of a release run this Docker file with the parameters
# --no-cache --build-arg DOWNLOAD=1.7.0
#
# The default download is the latest tip of the master of the named repository on GitHub
#
# Alternatively for local development, just copy this Dockerfile into file the root of the repository and 
# replace the whole RUN statement by the following COPY statement in your local source using :
#
# COPY . /opt/fiware-pep-steelskin/
#
# hadolint ignore=DL3008,DL4001,DL4006,DL3005
RUN apt-get update && \
	# Install security updates
	apt-get upgrade -y && \
	# Ensure that unzip, wget and curl are installed
	apt-get install -y --no-install-recommends unzip ca-certificates curl wget && \
	if [ "${DOWNLOAD}" = "latest" ] ; \
	then \
		RELEASE="${SOURCE_BRANCH}"; \
		echo "INFO: Building Latest Development from ${SOURCE_BRANCH} branch."; \
	elif [ "${DOWNLOAD}" = "stable" ]; \
	then \
		RELEASE=$(curl -s https://api.github.com/repos/"${GITHUB_ACCOUNT}"/"${GITHUB_REPOSITORY}"/releases/latest | grep 'tag_name' | cut -d\" -f4); \
		echo "INFO: Building Latest Stable Release: ${RELEASE}"; \
	else \
	 	RELEASE="${DOWNLOAD}"; \
	 	echo "INFO: Building Release: ${RELEASE}"; \
	fi && \
	RELEASE_CONCAT=$(echo "${RELEASE}" | tr / -); \
	wget --no-check-certificate -O source.zip https://github.com/"${GITHUB_ACCOUNT}"/"${GITHUB_REPOSITORY}"/archive/"${RELEASE}".zip && \
	unzip source.zip && \
	rm source.zip && \
	mv "${GITHUB_REPOSITORY}-${RELEASE_CONCAT}" /opt/fiware-pep-steelskin && \
	# Remove unzip and clean apt cache
	apt-get clean && \
	apt-get remove -y unzip && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/* 

WORKDIR /opt/fiware-pep-steelskin
# hadolint ignore=DL3008,DL3009,DL3015
RUN \
	# Ensure that Git is installed prior to running npm install
	apt-get update && \
	apt-get install -y git && \
	echo "INFO: npm install --production..." && \
	npm install --production && \
	# Remove Git and clean apt cache
	apt-get clean && \
	apt-get remove -y git && \
	apt-get -y autoremove && \
	chmod +x docker/entrypoint.sh

USER node
ENV NODE_ENV=production
ENV LOG_LEVEL=INFO

# Expose 1026 for TARGET PORT and 11211 for ADMIN PORT
EXPOSE ${TARGET_PORT:-1026} ${ADMIN_PORT:-11211}

ENTRYPOINT ["docker/entrypoint.sh"]
CMD ["-- ", "config.js"]

ENV CHECK_PORT=${ADMIN_PORT:-11211}
HEALTHCHECK --interval=60s --start-period=10s \
            CMD curl --fail -X GET http://localhost:${CHECK_PORT}/version || exit 1
