# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

FROM alpine:latest

LABEL maintainer Christoph Diehl <cdiehl@mozilla.com>

RUN apk --no-cache add \
    curl \
    && HADOLINT_VERSION=$( \
        curl -s "https://github.com/hadolint/hadolint/releases/latest" \
        | grep -o 'tag/[v.0-9]*' \
        | awk -F/ '{print $2}' \
    ) \
    && curl -sL -o /bin/hadolint "https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/hadolint-Linux-x86_64" \
    && chmod +x /bin/hadolint \
    && curl -sL https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz \
       | tar -xJ \
    && mv shellcheck-latest/shellcheck /bin/shellcheck \
    && rm -rf shellcheck-latest

WORKDIR /mnt

CMD ["/bin/bash"]
