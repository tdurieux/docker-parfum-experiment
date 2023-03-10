# Copyright 2016 The Kubernetes Authors All rights reserved.
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

FROM gcr.io/google_containers/ubuntu-slim:0.2
MAINTAINER Prashanth.B <beeps@google.com>

RUN apt-get update && apt-get install --no-install-recommends -y wget bash dnsutils && rm -rf /var/lib/apt/lists/*;
ADD peer-finder /peer-finder
ADD peer-finder.go /peer-finder.go

EXPOSE 9376
ENTRYPOINT ["/peer-finder"]
