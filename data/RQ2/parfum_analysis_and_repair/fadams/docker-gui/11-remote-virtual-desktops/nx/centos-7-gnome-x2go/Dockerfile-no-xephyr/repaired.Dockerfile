#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM centos-gnome-vgl:7.7

RUN yum -y install xorg-x11-drv-dummy \
    x2goserver x2goserver-xsession && \
    echo -e '[LightDM]\nminimum-display-number=1\n[Seat:*]\nuser-session=gnome\nxserver-command=Xorg -ac' > /etc/lightdm/lightdm.conf.d/70-centos.conf && rm -rf /var/cache/yum

COPY xorg.conf /etc/X11/xorg.conf

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t centos-gnome-x2go:7.7 -f Dockerfile-no-xephyr .

