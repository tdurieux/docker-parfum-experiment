#
# Copyright 2019 Atos Spain S.A
#
# This file is part of iotagent-lora
#
# iotagent-lora is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# iotagent-lora is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with iotagent-lora. If not, see http://www.gnu.org/licenses/.
#

ARG NODE_VERSION=fermium-slim

FROM node:${NODE_VERSION}

COPY . /opt/iotagent-lora/

WORKDIR /opt/iotagent-lora

RUN \

	apt-get update && \
	apt-get install --no-install-recommends -y git && \
	npm install pm2@3.2.2 -g && \
	echo "INFO: npm install --production..." && \
	npm install --production && \
	# Remove Git and clean apt cache
	apt-get clean && \
	apt-get remove -y git && \
	apt-get -y autoremove && \
	chmod +x docker/entrypoint.sh && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

USER node
ENV NODE_ENV=production

# Expose 4041 for NORTH PORT
EXPOSE ${IOTA_NORTH_PORT:-4041}

ENTRYPOINT ["docker/entrypoint.sh"]
CMD ["-- ", "config.js"]
