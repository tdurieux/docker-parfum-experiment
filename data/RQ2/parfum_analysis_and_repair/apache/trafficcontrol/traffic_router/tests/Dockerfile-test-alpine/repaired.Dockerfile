#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM alpine:3.13
ARG DIR=github.com/apache/trafficcontrol

VOLUME ["/junit"]

WORKDIR /go/src/$DIR/traffic_router

RUN apk add --no-cache \
		openjdk11 \
		maven \
		tomcat-native \
		bash

ADD traffic_router /go/src/$DIR/traffic_router

ENTRYPOINT /bin/bash "$@"
CMD set -o xtrace -o nounset && \
	export JAVA_HOME="$(command -v java | xargs realpath | xargs dirname)/.." && \
	mvn_command=(mvn) && \
	if [[ "$DEBUG_ENABLE" == true ]]; then\
		set -o nounset && \
		mvn_command+=("-Dmaven.surefire.debug=-agentlib:jdwp=transport=dt_socket,server=n,suspend=n,address=$DEBUG_HOST:$DEBUG_PORT -DforkCount=0 -DreuseForks=false"); \
	fi && \
	"${mvn_command[@]}" test -Djava.library.path=/usr/share/java -DoutputDirectory=/junit 2>&1; \
	exit_code=$? && \
	mv core/target/surefire-reports/* /junit && \
	exit $exit_code
#
# vi:syntax=Dockerfile