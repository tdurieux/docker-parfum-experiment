# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may
# not use this file except in compliance with the License. A copy of the
# License is located at
#
# 	http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

FROM golang:1.16-stretch

RUN apt-get update && apt-get install --yes --no-install-recommends \
	libprotobuf-dev \
	protobuf-compiler \
	&& go get -u github.com/containerd/ttrpc/cmd/protoc-gen-gogottrpc \
	&& go get -u github.com/gogo/protobuf/protoc-gen-gogo \
	&& mkdir /protobuf && rm -rf /var/lib/apt/lists/*;

WORKDIR /protobuf
ENTRYPOINT ["/usr/bin/make"]
CMD ["proto"]
