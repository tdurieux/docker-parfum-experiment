# Copyright (c) 2017, Groupon, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# Neither the name of GROUPON nor the names of its contributors may be
# used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This image is based on ansible-silo
FROM grpn/ansible-silo:{{ SILO_VERSION }}

# Define which Ansible version we want to use. Unlike the base silo image, this image has a hardcoded Ansible version:
ENV ANSIBLE_VERSION {{ ANSIBLE_VERSION }}

# Define the name of the image. We need to do this since the name is not available
# from inside the container but we use it in some scripts.
ENV SILO_IMAGE {{ BUNDLE_IMAGE }}

# Switch to above defined Ansible version
RUN /silo/entrypoint --switch "${ANSIBLE_VERSION}" silent

# Override functionality
ADD bundle_extension.sh /silo/bundle_extension.sh
ADD entrypoint /silo/entrypoint
RUN rm /silo/bin/*
ADD bin /silo/bin/
RUN chmod +x /silo/entrypoint

# Add playbooks etc.
ADD playbooks /home/user/playbooks
RUN chmod -R 777 /home/user/playbooks

# Set a version for your bundle. This will be shown when your bundle is called with the --version flag