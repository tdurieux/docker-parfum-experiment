# ==============================================================================
#  Copyright 2020 Intel Corporation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ==============================================================================

ARG tensorflow_version
ARG base_image
FROM $base_image as base

FROM tensorflow/tensorflow:$tensorflow_version

# Copy virtual environment from the previous layer
COPY --from=base /ngraph-bridge/build_cmake/python/dist /ngraph-bridge/whl/

# Copy ngraph-bridge examples
COPY --from=base /ngraph-bridge/examples /examples

RUN pip install --no-cache-dir /ngraph-bridge/whl/ngraph_tensorflow_bridge-*.whl
RUN python -c "import tensorflow as tf; print('TensorFlow version: ',tf.__version__);import ngraph_bridge; print(ngraph_bridge.__version__)"
