#
# Copyright 2020 Google LLC
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
#

################################################################################
#                                     BUILD                                    #
################################################################################

# Use our image that has bazel and all the apt's we need.
FROM gcr.io/cloud-spanner-emulator-builder/build-base as build

# Copy over the emulator code base into the container. We explicitly copy only
# the required files to maximize chances that the layer will be cached. There
# does not seem to be a nicer way to do this than multiple COPY commands as
# COPY copies the contents of the source, not the directory itself.
COPY BUILD.bazel WORKSPACE .bazelrc src/
COPY common      src/common/
COPY gateway     src/gateway/
COPY frontend    src/frontend/
COPY backend     src/backend/
COPY binaries    src/binaries/
COPY tests       src/tests/
COPY build/bazel src/build/bazel/

# Build the emulator.
RUN cd src                                                                  && \
    CC=/usr/bin/gcc CXX=/usr/bin/g++                                           \
    bazel build -c opt ...

# Generate licenses file.
RUN for file in $(find -L src/bazel-src/external                               \
                       -name "LICENSE" -o -name "COPYING")                   ; \
    do                                                                         \
      echo "----"                                                            ; \
      echo $file                                                             ; \
      echo "----"                                                            ; \
      cat $file                                                              ; \
    done > licenses.txt                                                     && \
    gzip licenses.txt

################################################################################
#                                   RELEASE                                    #
################################################################################

# Now build the release image from the build image.
FROM gcr.io/distroless/cc

# Copy binaries.
COPY --from=build /src/bazel-bin/binaries/emulator_main .
COPY --from=build /src/bazel-bin/binaries/gateway_main_/gateway_main .

# Copy licenses
COPY --from=build /licenses.txt.gz .

# Expose the default ports 9010 (gRPC) and 9020 (REST)
EXPOSE 9010 9020

# Run the gateway process, bind to 0.0.0.0 as under MacOS, listening on
# localhost will make the server invisible outside the container.