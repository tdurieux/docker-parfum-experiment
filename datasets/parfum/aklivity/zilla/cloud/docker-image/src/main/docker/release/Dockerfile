#
# Copyright 2021-2022 Aklivity Inc
#
# Licensed under the Aklivity Community License (the "License"); you may not use
# this file except in compliance with the License.  You may obtain a copy of the
# License at
#
#   https://www.aklivity.io/aklivity-community-license/
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#

FROM eclipse-temurin:17-alpine AS build

COPY maven /root/.m2/repository

COPY zpmw zpmw
COPY zpm.json zpm.json.template

RUN apk add --no-cache gettext
RUN cat zpm.json.template | env VERSION=${project.version} envsubst > zpm.json

RUN apk add --no-cache wget
RUN ./zpmw install --debug --exclude-remote-repositories
RUN ./zpmw clean --keep-image

FROM alpine

COPY --from=build /.zpm /.zpm
COPY --from=build /zilla /zilla

ENTRYPOINT ["./zilla"]
