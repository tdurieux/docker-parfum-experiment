#
#   Copyright (c) 2020 Project CHIP Authors
#   All rights reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

from generic_node_image
RUN apt-get install --no-install-recommends -y libglib2.0 && rm -rf /var/lib/apt/lists/*;
COPY out/debug/chip-lock-app /usr/bin/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh", "server"]
