# Copyright 2017-2021 EPAM Systems, Inc. (https://www.epam.com/)
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

FROM python:3.7-stretch

RUN apt-get update
RUN apt-get install -y build-essential python-dev
RUN pip install toil[all]==5.3.0 idna==2.10
ENV TMPDIR=/tmp
ENV TOIL_HOME=/toil_bin
ENV PATH="$PATH:$TOIL_HOME"
COPY cwl_inputs_parser.py cwl-runner $TOIL_HOME/
RUN chmod +x $TOIL_HOME/cwl-runner
