# Copyright 2020 Timothy Trippel
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

# Docker image for fuzzing various lock circuits with AFL
ARG FUZZER=sim
FROM hw-fuzzing/base-${FUZZER}
MAINTAINER trippel@umich.edu

# Test that TOPLEVEL argument was passed
ARG TOPLEVEL
RUN test -n "$TOPLEVEL"

# Create DUT directory
ENV DUT=$HW/$TOPLEVEL
RUN mkdir $DUT

# Pull down OpenTitan codebase from GitHub
RUN apt-get update && apt-get install -y git
ENV DUT_HDL_DIR=$HW/opentitan
RUN git clone --branch hwfuzz-checkpoint \
      https://github.com/timothytrippel/opentitan.git $DUT_HDL_DIR

# Checkout specific version of OpenTitan codebase
ARG VERSION=HEAD
RUN cd $DUT_HDL_DIR && git checkout ${VERSION}

# Copy in local files to the image
RUN test -n "$TOPLEVEL"
COPY $TOPLEVEL/hdl $DUT/hdl
COPY $TOPLEVEL/tb $DUT/tb
COPY $TOPLEVEL/seed_descriptions $DUT/seed_descriptions

# Copy in build scripts
COPY Makefile $DUT/

WORKDIR $DUT
CMD ["run"]
