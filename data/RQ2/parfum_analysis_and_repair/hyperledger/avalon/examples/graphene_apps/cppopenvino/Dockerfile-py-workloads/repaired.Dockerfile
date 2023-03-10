# Copyright 2020 Intel Corporation
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

FROM avalon-python-worker-dev

COPY ./ov_workload /home/openvino/ov_workload
COPY ./test/python_worker/test_ov_work_orders.json /home/openvino/ov_workload
COPY ./test/python_worker/ov_workload.json /home/openvino/ov_workload

WORKDIR /home/openvino/ov_workload

RUN python3 setup.py build_ext \
 && python3 setup.py bdist_wheel \
 && pip3 install --no-cache-dir dist/*

# Pass python file as docker command line argument
# This is required for Graphene.
CMD ["python"]

