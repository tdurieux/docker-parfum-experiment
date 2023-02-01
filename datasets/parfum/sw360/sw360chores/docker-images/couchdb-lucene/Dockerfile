# Copyright Bosch Software Innovations GmbH, 2016.
# Part of the SW360 Portal Project.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

FROM openjdk:11-jre-slim
MAINTAINER admin@sw360.org

WORKDIR /
ADD ./couchdb-lucene-2.1.0-dist.zip /
RUN set -ex \
 && apt-get update \
 && apt-get install -y unzip \
 && unzip /couchdb-lucene-2.1.0-dist.zip \
 && apt-get remove -y unzip \
 && mv /couchdb-lucene-2.1.0 /couchdb-lucene

EXPOSE 5985

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/couchdb-lucene/bin/run"]
