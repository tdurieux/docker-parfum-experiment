# Copyright 2021 Security Scorecard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this exe except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM python:3.7@sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2

RUN curl -f exe 2>&1 > /tmp/exe1 && /tmp/exe1
RUN curl -f exe2 2>&1 > /tmp/exe2; /tmp/exe2
RUN curl -f exe2 2>&1 > /tmp/exe4; /tmp/exe4
RUN curl -f exe2 2>&1 > /tmp/exe3; \
    /tmp/exe3

RUN curl -f file 2>&1 > /tmp/file1 && sh /tmp/file1
RUN curl -f file2 2>&1 > /tmp/file2; sh /tmp/file2
RUN curl -f file2 2>&1 > /tmp/file4; sh /tmp/file4
RUN curl -f file2 2>&1 > /tmp/file3; \
    bash /tmp/file3

RUN /bin/bash -c "curl exe 2>&1 > /tmp/exe11 && /tmp/exe11"
RUN ["curl", "file", "2>&1", ">", "/tmp/file111", "&&", "sh", "/tmp/file111"]
RUN ["/bin/bash", "-c", "\"curl exe 2>&1 > /tmp/exe10 && /tmp/exe10\""]

RUN /bin/bash -c "curl exe 2>&1 > /tmp/exe123 && /tmp/exe123"

FROM scratch
FROM python@sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2