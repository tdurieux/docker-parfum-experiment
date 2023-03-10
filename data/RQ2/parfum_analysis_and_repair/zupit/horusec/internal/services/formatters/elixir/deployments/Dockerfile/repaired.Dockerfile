# Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
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

FROM elixir:1.13-alpine

RUN apk add --no-cache git

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix escript.install hex mix_audit 1.0.0 --force
RUN mix archive.install hex sobelow 0.11.1 --force

RUN mv ./root/.mix/escripts/mix_audit ./bin/
