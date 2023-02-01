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

FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-trusty main" | tee /etc/apt/sources.list.d/mono-official-stable.list

RUN apt-get update && apt-get install --no-install-recommends -y \
    mono-devel \
    nuget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y unzip && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install dotnet CLI
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893
RUN apt-get update && apt-get install --no-install-recommends -y dotnet-dev-1.0.4 && rm -rf /var/lib/apt/lists/*;

# Trigger the population of the local package cache for dotnet CLI
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup

# Make sure the mono certificate store is up-to-date to prevent issues with nuget restore
RUN apt-get update && apt-get install --no-install-recommends -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://curl.haxx.se/ca/cacert.pem > ~/cacert.pem && cert-sync ~/cacert.pem && rm -f ~/cacert.pem
