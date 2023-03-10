# Copyright 2017 Adobe. All rights reserved.
# This file is licensed to you under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License. You may obtain a copy
# of the License at http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
# OF ANY KIND, either express or implied. See the License for the specific language
# governing permissions and limitations under the License.

FROM golang:1.11.0-alpine3.8
LABEL maintaner="Stegen Smith <matthsmi@adobe.com>"

ARG VERSION=$VERSION
ENV VERSION=$VERSION

### required for test
COPY ./files/doit.sh /doit.sh
COPY ./files/build_test_accept.sh /root/build.sh
COPY ./files/nginx.conf-accept /etc/nginx/nginx.conf
### required for test

### required to build
RUN mkdir -p /root/butler/cmd/butler /root/butler/internal/monitor /root/butler/internal/metrics /root/butler/internal/config /root/butler/internal/methods /root/butler/internal/reloaders /root/butler/internal/environment /root/butler/internal/alog
COPY ./cmd/butler/*.go /root/butler/cmd/butler/
COPY ./internal/config/*.go /root/butler/internal/config/
COPY ./internal/methods/*.go /root/butler/internal/methods/
COPY ./internal/reloaders/*.go /root/butler/internal/reloaders/
COPY ./internal/metrics/*.go /root/butler/internal/metrics/
COPY ./internal/monitor/*.go /root/butler/internal/monitor/
COPY ./internal/environment/*.go /root/butler/internal/environment/
COPY ./internal/alog/*.go /root/butler/internal/alog/
COPY ./vendor /root/butler/vendor
### required to build

RUN apk update && apk add --no-cache bash build-base ca-certificates curl git nginx

CMD ["/doit.sh"]
