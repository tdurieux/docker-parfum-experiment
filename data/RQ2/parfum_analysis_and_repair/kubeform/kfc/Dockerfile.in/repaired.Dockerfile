# Copyright The Kubeform Authors.
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

FROM debian:buster

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl unzip && rm -rf /var/lib/apt/lists/*;

RUN set -x \
  && curl -O -fsSL https://releases.hashicorp.com/terraform/{TERRAFORM_VER}/terraform_{TERRAFORM_VER}_{ARG_OS}_{ARG_ARCH}.zip \
  && unzip terraform_{TERRAFORM_VER}_{ARG_OS}_{ARG_ARCH}.zip \
  && chmod 755 terraform



FROM {ARG_FROM}

LABEL org.opencontainers.image.source https://github.com/kubeform/kfc

RUN set -x \
  && apk update \
  && apk add --update --no-cache ca-certificates tzdata git \
  && echo 'Etc/UTC' > /etc/timezone
ENV TZ     :/etc/localtime
ENV LANG   en_US.utf8

COPY bin/{ARG_OS}_{ARG_ARCH}/{ARG_BIN} /{ARG_BIN}
COPY --from=0 terraform /bin/terraform

# This would be nicer as `nobody:nobody` but distroless has no such entries.
# USER 65535:65535

ENTRYPOINT ["/{ARG_BIN}"]
