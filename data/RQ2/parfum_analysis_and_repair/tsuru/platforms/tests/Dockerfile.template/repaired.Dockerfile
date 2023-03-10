# Copyright 2016 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM platform-{PLATFORM}
WORKDIR /tests
ADD . /tests
ADD common/* /tests/common/
# These RUN true lines are an ugly hack due to
# https://github.com/moby/moby/issues/37965 and
# https://github.community/t/attempting-to-build-docker-image-with-copy-from-on-actions/16715
RUN true
ADD https://github.com/bats-core/bats-core/archive/master.tar.gz ./bats.tar.gz
RUN true
ADD https://github.com/bats-core/bats-support/archive/master.tar.gz ./bats-support.tar.gz
RUN true
ADD https://github.com/bats-core/bats-assert/archive/master.tar.gz ./bats-assert.tar.gz
RUN sudo mkdir ./bin && \
    sudo tar -zxf bats.tar.gz && \
    sudo tar -zxf bats-support.tar.gz && \
    sudo tar -zxf bats-assert.tar.gz && \
    sudo ./bats-core-master/install.sh . && rm bats.tar.gz
RUN echo "echo 'ran base deploy'" | sudo tee /var/lib/tsuru/base/deploy
RUN bin/bats common && bin/bats .
