# Copyright 2018 Google LLC
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

FROM grpcweb/prereqs

WORKDIR /github/grpc-web/net/grpc/gateway/examples/echo

RUN protoc -I=. echo.proto \
--js_out=import_style=commonjs:./commonjs-example \
--grpc-web_out=import_style=commonjs,mode=grpcwebtext:./commonjs-example

WORKDIR /github/grpc-web/net/grpc/gateway/examples/echo/commonjs-example

RUN npm install && \
  npm link grpc-web && \
  npx webpack && \
  cp echotest.html /var/www/html && \
  cp dist/main.js /var/www/html/dist && npm cache clean --force;

WORKDIR /var/www/html

EXPOSE 8081
CMD ["python", "-m", "SimpleHTTPServer", "8081"]
