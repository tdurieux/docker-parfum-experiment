# Copyright 2015 gRPC authors.
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

FROM opensuse/leap:latest

RUN zypper --non-interactive install python3
RUN zypper --non-interactive install python3-pip

# "which" command required by python's run_distrib_test.sh
RUN zypper --non-interactive install which

# Without this, pip won't be able to connect to
# https://pypi.python.org/simple/