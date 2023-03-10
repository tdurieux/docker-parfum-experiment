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
ARG buildver=7.6.1.2
ARG libertyver=20.0.0.3-kernel-java8-ibmjava
ARG namespace=maximo-liberty

FROM ${namespace}/images:${buildver}
FROM websphere-liberty:${libertyver}

LABEL maintainer="nishi2go@gmail.com"

# Install required packages