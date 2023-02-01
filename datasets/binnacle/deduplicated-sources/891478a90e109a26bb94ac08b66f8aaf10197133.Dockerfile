# Copyright 2015 Skippbox, Ltd
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

FROM hypriot/rpi-golang

RUN mkdir -p /go/src/app
RUN mkdir -p /var/lib/etcd
WORKDIR /go/src/app
ENV ETCD_UNSUPPORTED_ARCH="arm"

# this will ideally be built by the ONBUILD below ;)
CMD ["go-wrapper", "run"]

COPY . /go/src/app
RUN mv /go/src/app/go-wrapper /goroot/bin/go-wrapper
RUN chmod +x /goroot/bin/go-wrapper
RUN go-wrapper download
RUN go-wrapper install

ENTRYPOINT ["etcd"]

EXPOSE 4001 7001 2379 2380
