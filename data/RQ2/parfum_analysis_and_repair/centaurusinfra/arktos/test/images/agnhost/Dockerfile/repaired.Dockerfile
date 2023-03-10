# Copyright 2019 The Kubernetes Authors.
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

FROM BASEIMAGE

CROSS_BUILD_COPY qemu-QEMUARCH-static /usr/bin/

# from hostexec image
# install necessary packages:
# - curl, nc: used by a lot of e2e tests
# - iproute2: includes ss used in NodePort tests
RUN apk --update --no-cache add curl netcat-openbsd iproute2 && rm -rf /var/cache/apk/*

# PORT 8080 needed by: netexec, nettest
# PORT 8081 needed by: netexec
EXPOSE 8080 8081

# from netexec
RUN mkdir /uploads

ADD agnhost agnhost
ENTRYPOINT ["/agnhost"]
CMD ["pause"]
