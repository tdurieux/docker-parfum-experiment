# Copyright 2018 The Gluster CSI Authors.

# Licensed under GNU LESSER GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# You may obtain a copy of the License at
#    https://opensource.org/licenses/lgpl-3.0.html

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#-- Create build environment

FROM docker.io/openshift/origin-release:golang-1.11 as build

ENV GOPATH="/go/" \
    SRCDIR="/go/src/github.com/gluster/gluster-csi-driver/" \
    SCRIPTSDIR="${SRCDIR}scripts/"

RUN yum install -y \
    git && rm -rf /var/cache/yum

# Install go tools
ARG GO_DEP_VERSION=
ARG GO_METALINTER_VERSION=latest
COPY scripts/install-go-tools.sh "${SCRIPTSDIR}"
RUN mkdir -p /go/bin; ${SCRIPTSDIR}/install-go-tools.sh

# Vendor dependencies
COPY Gopkg.lock Gopkg.toml "${SRCDIR}"
WORKDIR "${SRCDIR}"
RUN /go/bin/dep ensure -v -vendor-only

# Copy source directories
COPY cmd/ "${SRCDIR}/cmd"
COPY pkg/ "${SRCDIR}/pkg"
COPY scripts/ "${SCRIPTSDIR}"

#-- Test phase

ARG RUN_TESTS=1
ARG GO_METALINTER_THREADS=1
ENV TEST_COVERAGE=stdout \
    GO_COVER_DIR=/build/

RUN mkdir /build
RUN [ $RUN_TESTS -eq 0 ] || ${SCRIPTSDIR}/lint-go.sh
RUN [ $RUN_TESTS -eq 0 ] || ${SCRIPTSDIR}/test-go.sh

#-- Build phase

# Build executable
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags '-extldflags "-static"' -o /build/glustervirtblock-csi-driver cmd/gluster-virtblock/main.go

# Ensure the binary is statically linked
RUN ldd /build/glustervirtblock-csi-driver | grep -q "not a dynamic executable"

#-- Final container

FROM docker.io/centos:7 as final

# Install dependencies
ADD http://artifacts.ci.centos.org/gluster/nightly/release-6.repo  /etc/yum.repos.d/glusterfs-nightly.repo
RUN yum update -y && \
    yum -y install glusterfs-fuse xfsdump xfsprogs -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum && \
    rpm -qa | grep gluster | tee /gluster-rpm-versions.txt

# Copy glustervirtblock-csi-driver from build phase
COPY --from=build /build /

# The version of the driver (git describe --dirty --always --tags | sed 's/-/./2' | sed 's/-/./2')
ARG version="(unknown)"
# Container build time (date -u '+%Y-%m-%dT%H:%M:%S.%NZ')
ARG builddate="(unknown)"

LABEL build-date="${builddate}"
LABEL io.k8s.description="FUSE-based CSI driver for Gluster block access"
LABEL name="glustervirtblock-csi-driver"
LABEL Summary="FUSE-based CSI driver for Gluster block access"
LABEL vcs-type="git"
LABEL vcs-url="https://github.com/gluster/gluster-csi-driver"
LABEL vendor="gluster.org"
LABEL version="${version}"

ENTRYPOINT ["/glustervirtblock-csi-driver"]
