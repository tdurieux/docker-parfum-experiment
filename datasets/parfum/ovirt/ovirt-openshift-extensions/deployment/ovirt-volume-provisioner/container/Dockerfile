# Copyright 2018 oVirt-maintainers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM registry.svc.ci.openshift.org/openshift/release:golang-1.11 AS builder

ARG version 
ARG release

LABEL   com.redhat.component="ovirt-openshift-extensions" \
        name="ovirt-volume-provisioner" \
        version="$version" \
        release="$release" \
        architecture="x86_64" \
        summary="ovirt-volume-provisioner for openshift, for dynamic volume provisioning" \
        maintainer="Roy Golan <rgolan@redhat.com>"

WORKDIR /go/src/github.com/ovirt/ovirt-openshift-extensions
ADD ovirt-openshift-extensions-$version-$release.tar.gz .

RUN make ovirt-volume-provisioner

FROM registry.access.redhat.com/ubi8/ubi-minimal

COPY --from=builder /go/src/github.com/ovirt/ovirt-openshift-extensions/ovirt-volume-provisioner /usr/bin/

ENTRYPOINT ["/usr/bin/ovirt-volume-provisioner"]
