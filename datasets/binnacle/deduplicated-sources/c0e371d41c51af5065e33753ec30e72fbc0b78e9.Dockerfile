# Copyright 2018 Google, Inc. All rights reserved.
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

# Builds the static Go image for Admission validation controller.

FROM golang:1.10
WORKDIR /go/src/github.com/grafeas/kritis
COPY . .
RUN make out/gcb-signer

FROM gcr.io/distroless/base:latest
COPY --from=0 /go/src/github.com/grafeas/kritis/out/gcb-signer /kritis/gcb-signer
ENV HOME /root
ENV USER /root
ENV PATH /usr/local/bin:/kritis
ENTRYPOINT ["/kritis/gcb-signer"]
