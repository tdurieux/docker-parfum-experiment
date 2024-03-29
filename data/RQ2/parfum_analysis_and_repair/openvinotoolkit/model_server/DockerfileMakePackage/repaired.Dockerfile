#
# Copyright (c) 2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ARG BUILD_IMAGE=ovms-redhat:latest

FROM $BUILD_IMAGE

ARG ov_use_binary=1
SHELL ["/bin/bash", "-c"]

RUN mkdir /patchelf && cd /patchelf && \
	wget https://github.com/NixOS/patchelf/archive/0.10.tar.gz && \
	tar -xf 0.10.tar.gz && ls -lah && cd */ && \
	./bootstrap.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm 0.10.tar.gz

RUN mkdir -vp /ovms_release/bin
RUN mkdir -vp /ovms_release/deps
RUN mkdir -vp /ovms_release/lib
RUN mkdir -vp /ovms_release/lib/hddl/config

RUN cp /ovms/metadata.json /ovms_release/
RUN if [ "$ov_use_binary" == "0" ] ; then true ; else exit 0 ; fi ; cp -v /openvino/bin/intel64/Release/lib/plugins.xml /ovms_release/lib/
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; cp -v /opt/intel/openvino/runtime/3rdparty/hddl/config/* /ovms_release/lib/hddl/config/ || true
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; cp -vr /opt/intel/openvino/runtime/3rdparty/hddl/etc/* /ovms_release/lib/hddl/etc/ || true
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; cp -v /opt/intel/openvino/runtime/lib/intel64/plugins.xml /ovms_release/lib/ && cp /opt/intel/openvino/install_dependencies/* /ovms_release/deps/
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; rm -vrf /ovms_release/deps/*-devel-*

RUN find /ovms/bazel-out/k8-*/bin -iname '*.so*' -exec cp -v {} /ovms_release/lib/ \;
RUN cd /ovms_release/lib/ ; rm -f libazurestorage.so.* ; ln -s libazurestorage.so libazurestorage.so.7 ;ln -s libazurestorage.so libazurestorage.so.7.5
RUN cd /ovms_release/lib/ ; rm -f libcpprest.so.2.10 ; ln -s libcpprest.so libcpprest.so.2.10
RUN rm -f /ovms_release/lib/libssl.so
RUN rm -f /ovms_release/lib/libsampleloader*
RUN rm -f /ovms_release/lib/lib_node*
RUN rm -f /ovms_release/lib/libcustom_node*

RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; find /opt/intel/openvino/runtime/lib/intel64/ -iname '*.so*' -exec cp -vP {} /ovms_release/lib/ \;
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; find /opt/intel/openvino/runtime/lib/intel64/ -iname '*.mvcmd*' -exec cp -v {} /ovms_release/lib/ \;
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; find /opt/intel/openvino/runtime/3rdparty/ -iname '*.so*' -exec cp -vP {} /ovms_release/lib/ \;
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; find /opt/intel/openvino/extras/opencv/lib/ -iname '*.so*' -exec cp -vP {} /ovms_release/lib/ \; && rm /ovms_release/lib/libopencv_highgui*
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; cp /opt/intel/openvino/extras/opencv/etc/licenses/* /ovms/release_files/thirdparty-licenses/;
RUN if [ "$ov_use_binary" == "1" ] ; then true ; else exit 0 ; fi ; if [ -f /opt/intel/openvino/docs/licensing/EULA.txt ] ; then true ; else exit 0; fi ; cp /opt/intel/openvino/docs/licensing/EULA.txt /ovms/release_files/thirdparty-licenses/openvino.LICENSE.txt;
RUN if [ "$ov_use_binary" == "0" ] ; then true ; else exit 0 ; fi ; cp /openvino/LICENSE /ovms/release_files/thirdparty-licenses/openvino.LICENSE.txt;

RUN find /ovms/bazel-bin/src -name 'ovms' -type f -exec cp -v {} /ovms_release/bin \;
WORKDIR /ovms_release/bin
RUN patchelf --remove-rpath ./ovms && patchelf --set-rpath '$ORIGIN/../lib/' ./ovms
RUN find /ovms_release/lib/ -iname '*.so*' -exec patchelf --debug --remove-rpath  {}  \;
RUN find /ovms_release/lib/ -iname '*.so*' -exec patchelf --debug --set-rpath '$ORIGIN/../lib' {} \;

WORKDIR /ovms
RUN cp -v /ovms/release_files/LICENSE /ovms_release/
RUN cp -rv /ovms/release_files/thirdparty-licenses /ovms_release/

RUN ls -lahR /ovms_release/

RUN find /ovms_release/lib/ -iname '*.so*' -type f -exec patchelf --remove-rpath  {}  \;
RUN find /ovms_release/lib/ -iname '*.so*' -type f -exec patchelf --set-rpath '$ORIGIN/../lib' {} \;

WORKDIR /
RUN tar czf ovms.tar.gz --transform 's/ovms_release/ovms/' /ovms_release/ && sha256sum ovms.tar.gz > ovms.tar.gz.sha256 && cp /ovms_release/metadata.json /ovms.tar.gz.metadata.json
RUN tar cJf ovms.tar.xz --transform 's/ovms_release/ovms/' /ovms_release/ && sha256sum ovms.tar.xz > ovms.tar.xz.sha256 && cp /ovms_release/metadata.json /ovms.tar.xz.metadata.json

ENTRYPOINT [ ]
