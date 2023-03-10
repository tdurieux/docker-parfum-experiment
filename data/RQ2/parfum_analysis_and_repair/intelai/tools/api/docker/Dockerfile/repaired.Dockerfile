#
# Copyright (c) 2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

FROM intelaipg/intel-optimized-tensorflow:1.15.0-mkl-py3 as binary_build

ENV WORKSPACE="/workspace"
WORKDIR ${WORKSPACE}
RUN pip install --no-cache-dir intel-quantization

CMD ["/bin/bash"]

