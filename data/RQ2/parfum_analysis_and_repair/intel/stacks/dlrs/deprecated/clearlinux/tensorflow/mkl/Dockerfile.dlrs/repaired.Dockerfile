FROM stacks-tf-mkl as tf_builder
FROM stacks-openvino-omp as serving_builder
#---------------------------------------------------------------------
# DLRS downstream container
#---------------------------------------------------------------------
FROM clearlinux-dlrs-builder as base
LABEL maintainer=otc-swstacks@intel.com

ARG HOROVOD_VERSION=0.19.1
ARG MODEL_SERVER_TAG=v2020.1

COPY --from=tf_builder /tmp/tf/ /tmp/tf/
COPY --from=serving_builder /dldt/bin/intel64/Release/lib/ /usr/local/lib/inference-engine/

COPY --from=serving_builder /dldt/inference-engine/include/*.h* /usr/local/include/inference-engine/include/
COPY --from=serving_builder /dldt/inference-engine/include/cpp/ /usr/local/include/inference-engine/include/cpp/
COPY --from=serving_builder /dldt/inference-engine/include/details /usr/local/include/inference-engine/include/details
COPY --from=serving_builder /dldt/inference-engine/include/multi-device /usr/local/include/inference-engine/include/multi-device


# install tensorflow, ntlk, jupyterhub, opencv, seldon-core and horovod
RUN pip --no-cache-dir install /tmp/tf/avx512/tensorflow*.whl \
    && rm -rf /tmp/tf
RUN pip --no-cache-dir install horovod==${HOROVOD_VERSION}
RUN npm install -g configurable-http-proxy \
    && pip --no-cache-dir install common seldon-core jupyterhub \
    && pip --no-cache-dir install notebook protobuf \
    && pip --no-cache-dir install numpy tensorflow-serving-api==1.15.0 google-cloud-storage boto3 jsonschema falcon cheroot \
    && pip --no-cache-dir install grpcio defusedxml==0.5.0 grpcio-tools test-generator==0.1.1 \
    && npm cache clean --force \
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete 


# install openvino inference engine
# init
ENV BASH_ENV /usr/share/defaults/etc/profile
RUN echo "export LD_LIBRARY_PATH=/usr/local/lib/inference-engine:/usr/local/lib" >> /etc/profile \
    && echo "export PYTHONPATH=/usr/local/lib/inference-engine/python_api/python3.8:/usr/local/lib/inference-engine/python_api/python3.8/openvino/inference_engine/" >> /etc/profile

# init ie serving
WORKDIR /ie_serving_py
RUN git clone --depth 1 -b ${MODEL_SERVER_TAG} https://github.com/IntelAI/OpenVINO-model-server.git model_server \
    && cd model_server && git checkout ${MODEL_SERVER_TAG} && cd .. \
    && cp ./model_server/setup.py /ie_serving_py \
    && echo "OpenVINO Model Server version: ${MODEL_SERVER_TAG}" > /ie_serving_py/version \
    && echo "Git commit: `cd ./model_server; git rev-parse HEAD; cd ..`" >> /ie_serving_py/version \
    && echo "OpenVINO version: ${MODEL_SERVER_TAG} src" >> /ie_serving_py/version \
    && echo "# OpenVINO built with: https://github.com/opencv/dldt.git" >> /ie_serving_py/version \
    && cp -r ./model_server/ie_serving /ie_serving_py/ie_serving \
    && cd /ie_serving_py && python setup.py install \
    && rm -rf model_server

WORKDIR /workspace
COPY /scripts/ /workspace/scripts/
RUN chmod -R a+w /workspace
SHELL ["/bin/bash", "-c"]