# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
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
# ==============================================================================

# This docker configuration file lets you emulate a Hifive1 board
# on an x86 desktop or laptop, which can be useful for debugging and
# automated testing.
FROM antmicro/renode:latest

LABEL maintainer="Pete Warden <petewarden@google.com>"

RUN apt-get update && apt-get install --no-install-recommends -y curl git unzip make g++ && rm -rf /var/lib/apt/lists/*;