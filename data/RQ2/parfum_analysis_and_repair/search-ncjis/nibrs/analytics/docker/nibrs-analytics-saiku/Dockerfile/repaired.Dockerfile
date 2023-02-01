#
# Copyright 2016 SEARCH-The National Consortium for Justice Information and Statistics
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Dockerfile that extends base saiku to add demo data sources

FROM ojbc/saiku:ojbc-3.17-saml

# set this arg to dev to create an image where the default (admin) saiku user has admin privileges
# do this by passing --build-arg MODE=dev
ARG MODE=prod

WORKDIR /tmp

COPY files/server-config.sh /tmp/
COPY files/Analytics.connection.json /tmp/

# need to copy this from ../../mondrian/NIBRSAnalyticsMondrianSchema.xml to files/