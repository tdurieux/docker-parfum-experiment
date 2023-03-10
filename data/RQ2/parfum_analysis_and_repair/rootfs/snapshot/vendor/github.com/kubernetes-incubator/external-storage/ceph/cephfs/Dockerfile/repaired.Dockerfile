# Copyright 2017 The Kubernetes Authors.
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

FROM centos:7
RUN rpm -Uvh https://download.ceph.com/rpm-jewel/el7/noarch/ceph-release-1-1.el7.noarch.rpm
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y ceph-common python-cephfs && rm -rf /var/cache/yum
ADD cephfs-provisioner /usr/local/bin/cephfs-provisioner
ADD cephfs_provisioner/cephfs_provisioner.py /usr/local/bin/cephfs_provisioner
CMD chmod x+o /usr/local/bin/cephfs_provisioner
