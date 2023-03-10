##
##    Docker image for ERPNext.
##    Copyright (C) 2020  Monogramm
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU Affero General Public License as published
##    by the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU Affero General Public License for more details.
##
##    You should have received a copy of the GNU Affero General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
FROM monogramm/docker-frappe:11-debian

ARG VERSION=version-11-hotfix

# Build environment variables
ENV ERPNEXT_BRANCH=${VERSION} \
    FRAPPE_APP_PROTECTED='frappe erpnext' \
    DOCKER_GUNICORN_TIMEOUT=600

# Setup ERPNext
RUN set -ex; \
    sudo mkdir -p "/home/$FRAPPE_USER"/frappe-bench/logs; \
    sudo touch "/home/$FRAPPE_USER"/frappe-bench/logs/bench.log; \
    sudo chmod 777 \
        "/home/$FRAPPE_USER"/frappe-bench/logs \
        "/home/$FRAPPE_USER"/frappe-bench/logs/* \
    ; \
    bench get-app --branch "$ERPNEXT_BRANCH" erpnext https://github.com/frappe/erpnext; \
    sudo ./env/bin/pip3 install \
        ldap3 \
    ;

VOLUME /home/$FRAPPE_USER/frappe-bench/apps/erpnext/erpnext/public

ARG TAG
ARG VCS_REF
ARG BUILD_DATE

# Build environment variables