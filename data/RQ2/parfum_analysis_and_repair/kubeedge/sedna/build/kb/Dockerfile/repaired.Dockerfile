# Copyright 2021 The KubeEdge Authors.
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

FROM python:3.6-slim

RUN pip install --no-cache-dir colorlog~=4.7.2
RUN pip install --no-cache-dir PyYAML~=5.4.1
RUN pip install --no-cache-dir fastapi~=0.63.0
RUN pip install --no-cache-dir starlette~=0.13.6
RUN pip install --no-cache-dir pydantic~=1.8.1
RUN pip install --no-cache-dir joblib~=1.0.1
RUN pip install --no-cache-dir pandas~=1.1.5
RUN pip install --no-cache-dir uvicorn~=0.14.0
RUN pip install --no-cache-dir python-multipart~=0.0.5
RUN pip install --no-cache-dir SQLAlchemy~=1.4.7
RUN pip install --no-cache-dir aiofiles~=0.7.0

RUN mkdir /code
ENV PYTHONPATH "/code/lib"

COPY ./lib /code/lib


ENTRYPOINT ["python", "/code/lib/sedna/service/run_kb.py"]
