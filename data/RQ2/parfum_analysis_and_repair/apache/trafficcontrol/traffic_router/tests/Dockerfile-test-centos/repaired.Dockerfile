#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM centos:7
ARG DIR=github.com/apache/trafficcontrol

VOLUME ["/junit"]

WORKDIR /go/src/$DIR/traffic_router

RUN set -o errexit; \
	yum -y update; \
	yum -y install \
		maven \
		java-11-openjdk \
		epel-release; rm -rf /var/cache/yum \
	yum -y install tomcat-native; \
	yum -y clean all

ADD traffic_router /go/src/$DIR/traffic_router

CMD set -o xtrace && \
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
