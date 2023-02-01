# Copyright 2016 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM platform-{PLATFORM}
WORKDIR /tests
ADD . /tests
ADD common/* /tests/common/
ADD https://github.com/sstephenson/bats/archive/master.tar.gz .
RUN sudo mkdir ./bin && sudo tar -zxf master.tar.gz && sudo ./bats-master/install.sh .
RUN echo "echo 'ran base deploy'" | sudo tee /var/lib/tsuru/base/deploy
RUN sudo bin/bats common && sudo bin/bats .
