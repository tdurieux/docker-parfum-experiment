# Cerberus Copyright (C) 2016 Cerberus Testing
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This file is part of Cerberus.
#
# Cerberus is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Cerberus is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Cerberus. If not, see <http://www.gnu.org/licenses/>.
FROM glassfish:4.1
MAINTAINER cerberustesting

# Database related environment variables
# Could be overridden by user
ENV DATABASE_TYPE mysql
ENV DATABASE_HOST cerberus-db-mysql
ENV DATABASE_PORT 3306
ENV DATABASE_NAME cerberus
ENV DATABASE_USER cerberus
ENV DATABASE_PASSWORD toto

# Internal environment variables
# Should not be overridden by user
ENV CERBERUS_NAME Cerberus
ENV CERBERUS_VERSION 1.1.3.1
ENV CERBERUS_PACKAGE_NAME ${CERBERUS_NAME}-${CERBERUS_VERSION}
ENV GLASSFISH_ADMIN_USER admin
ENV GLASSFISH_DOMAIN domain1

# Get and extract the Cerberus package
# Use RUN instead of ADD to avoid re-download (see https://github.com/docker/docker/issues/15717)
RUN curl -f -L -o /tmp/${CERBERUS_PACKAGE_NAME}.zip https://sourceforge.net/projects/cerberus-source/files/${CERBERUS_PACKAGE_NAME}.zip/download && \
    unzip -q -d /tmp /tmp/${CERBERUS_PACKAGE_NAME}.zip

# Create the screenshot directory
RUN mkdir /opt/cerberus-screenshots
RUN chmod u+wx /opt/cerberus-screenshots

# Glassfish credentials files
COPY glassfish_admin_set_password.txt /tmp/glassfish_admin_set_password.txt
COPY glassfish_admin_password.txt /tmp/glassfish_admin_password.txt

# Start Glassfish initialization and execution
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Start Glassfish instance with the verbose option to remain in the foreground so that docker can track it
ENV ASADMIN="asadmin --user ${GLASSFISH_ADMIN_USER} --passwordfile /tmp/glassfish_admin_password.txt"
CMD ${ASADMIN} start-domain --verbose ${GLASSFISH_DOMAIN}