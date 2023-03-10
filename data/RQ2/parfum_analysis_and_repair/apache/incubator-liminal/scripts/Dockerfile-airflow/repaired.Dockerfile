#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM apache/airflow:2.1.2-python3.8

ARG LIMINAL_VERSION='apache-liminal'
ARG DAG_FOLDER='/opt/airflow/dags/'
ADD scripts/* ${DAG_FOLDER}
ADD *.whl ${DAG_FOLDER}

RUN ls -ls ${DAG_FOLDER}
ADD liminal/runners/airflow/dag/liminal_dags.py ${DAG_FOLDER}
ADD scripts/webserver_config.py /opt/airflow/

USER airflow

RUN pip --disable-pip-version-check --no-cache-dir install -r /opt/airflow/dags/requirements-airflow.txt --user
RUN pip --disable-pip-version-check --no-cache-dir install --user ${LIMINAL_VERSION}
