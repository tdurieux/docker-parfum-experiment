############################################################
# Dockerfile to build Traffic Ops Url Rewriter container images
# Based on NGINX 1.9
############################################################
#
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

# Example Build and Run:
# docker build --file Url_Rewriter_Dockerfile --rm --tag traffic_ops_url_rewriter:0.1 .
# docker run --add-host="localhost:10.0.2.2" -p 9008:9008 --name my-tour --hostname my-tour --detach traffic_ops_url_rewriter:0.1