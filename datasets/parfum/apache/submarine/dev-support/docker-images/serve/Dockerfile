# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile
FROM continuumio/miniconda3

# mlflow serve dependency
RUN pip install mlflow boto3

# some envs
ENV MLFLOW_S3_ENDPOINT_URL="http://submarine-minio-service:9000"
ENV AWS_ACCESS_KEY_ID="submarine_minio"
ENV AWS_SECRET_ACCESS_KEY="submarine_minio"
ENV MLFLOW_TRACKING_URI="http://submarine-mlflow-service:5000"