# Copyright 2020 Google LLC
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

FROM gcr.io/fuzzbench/base-image

RUN apt-get update -y && \
	apt-get install --no-install-recommends -y \
	google-perftools \
	llvm-6.0 llvm-6.0-dev llvm-6.0-tools && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y clang-6.0 vim less && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir psutil==5.7.2
