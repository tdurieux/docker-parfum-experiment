# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG REPOSITORY_LOCATION
ARG PROJECT_ID
ARG REPOSITORY_ID
ARG OPENLANE_VERSION
FROM $REPOSITORY_LOCATION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_ID/openlane-pdk:$OPENLANE_VERSION

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /conda-env && rm Miniconda3-latest-Linux-x86_64.sh

# install openlane dependencies in conda environment
RUN /conda-env/bin/conda install -c conda-forge -y python pip
# install openlane dependencies in conda environment