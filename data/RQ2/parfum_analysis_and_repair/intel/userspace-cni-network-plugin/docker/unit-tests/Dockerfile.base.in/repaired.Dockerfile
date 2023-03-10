// Copyright 2020 Intel Corp.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// install GO version set by argument or fallback to default ver.
ARG UT_GO_VERSION=1.14.3
RUN wget "https://dl.google.com/go/go${UT_GO_VERSION}.linux-amd64.tar.gz" && \\
    tar -C "/usr/local" -xzf "go${UT_GO_VERSION}.linux-amd64.tar.gz" && \\
    rm "go${UT_GO_VERSION}.linux-amd64.tar.gz"
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH="/root/go"
ENV GOROOT="/usr/local/go"
RUN mkdir $GOPATH

// install unit test specific go modules
RUN go get -u "github.com/msoap/go-carpet"
RUN ln -s $(go env GOPATH)/bin/go-carpet /usr/local/bin/go-carpet

// copy userspace CNI plugin code and tests from host to container
RUN mkdir -p $GOPATH/src/github.com/intel/userspace-cni-network-plugin
COPY ./ $GOPATH/src/github.com/intel/userspace-cni-network-plugin/

// download dependencies and generate VPP binapi code
WORKDIR $GOPATH/src/github.com/intel/userspace-cni-network-plugin
RUN make install-dep
RUN make install
RUN make