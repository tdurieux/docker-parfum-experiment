# Copyright 2018-present Open Networking Foundation
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

# docker build -t smbaker/testservice-synchronizer:test -f Dockerfile.synchronizer ..

# xosproject/testservice

FROM xosproject/alpine-grpc-base:0.9.0

# Add libraries
COPY lib /opt/xos/lib
COPY VERSION /opt/xos

# Install non-xos pip packages
COPY testservice/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
 && pip freeze > /var/xos/pip_freeze_requirements_`date -u +%Y%m%dT%H%M%S`

# Install xos packages using pip so their dependencies are installed
RUN pip install --no-cache-dir -e /opt/xos/lib/xos-config \
 && pip install --no-cache-dir -e /opt/xos/lib/xos-genx \
 && pip install --no-cache-dir -e /opt/xos/lib/xos-kafka \
 && pip install --no-cache-dir -e /opt/xos/lib/xos-api \
 && pip install --no-cache-dir -e /opt/xos/lib/xos-synchronizer \
 && pip freeze > /var/xos/pip_freeze_libraries_`date -u +%Y%m%dT%H%M%S`

# Install the synchronizer
COPY testservice/xos/synchronizer /opt/xos/synchronizers/testservice

ENTRYPOINT []

WORKDIR "/opt/xos/synchronizers/testservice"

# Label image
ARG org_label_schema_schema_version=1.0
ARG org_label_schema_name=testservice
ARG org_label_schema_version=unknown
ARG org_label_schema_vcs_url=unknown
ARG org_label_schema_vcs_ref=unknown
ARG org_label_schema_build_date=unknown
ARG org_opencord_vcs_commit_date=unknown
ARG org_opencord_component_chameleon_version=unknown
ARG org_opencord_component_chameleon_vcs_url=unknown
ARG org_opencord_component_chameleon_vcs_ref=unknown
ARG org_opencord_component_xos_version=unknown
ARG org_opencord_component_xos_vcs_url=unknown
ARG org_opencord_component_xos_vcs_ref=unknown

LABEL org.label-schema.schema-version=$org_label_schema_schema_version \
      org.label-schema.name=$org_label_schema_name \
      org.label-schema.version=$org_label_schema_version \
      org.label-schema.vcs-url=$org_label_schema_vcs_url \
      org.label-schema.vcs-ref=$org_label_schema_vcs_ref \
      org.label-schema.build-date=$org_label_schema_build_date \
      org.opencord.vcs-commit-date=$org_opencord_vcs_commit_date \
      org.opencord.component.chameleon.version=$org_opencord_component_chameleon_version \
      org.opencord.component.chameleon.vcs-url=$org_opencord_component_chameleon_vcs_url \
      org.opencord.component.chameleon.vcs-ref=$org_opencord_component_chameleon_vcs_ref \
      org.opencord.component.xos.version=$org_opencord_component_xos_version \
      org.opencord.component.xos.vcs-url=$org_opencord_component_xos_vcs_url \
      org.opencord.component.xos.vcs-ref=$org_opencord_component_xos_vcs_ref

CMD ["/usr/bin/python", "/opt/xos/synchronizers/testservice/testservice-synchronizer.py"]

