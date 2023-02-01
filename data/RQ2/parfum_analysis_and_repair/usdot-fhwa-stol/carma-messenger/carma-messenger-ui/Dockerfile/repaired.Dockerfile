#  Copyright (C) 2018-2021 LEIDOS.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License. You may obtain a copy of
#  the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#  License for the specific language governing permissions and limitations under
#  the License.

# CARMA Web Interface Docker Configuration Script
#
# Performs all necessary tasks related to generation of a docker image set up
# to serve the CARMA web-based user interface via Apache and interact with the
# host's docker daemon as needed to start and stop the CARMA application itself
# 
# In order to enable the web-start functionality please run this image with
# -v /var/run/docker.sock:/var/run/docker.sock