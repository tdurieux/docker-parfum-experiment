# Example tensorflow-model-server-neuron dockerfile.

# Note: tensorflow_model_server_neuron must be pointed at the model location and name using MODEL_BASE_PATH and
# MODEL_NAME env variables. MODEL_BASE_PATH may be an s3 location.

# To build:
#    docker build . -f Dockerfile.tf-serving -t tensorflow-model-server-neuron


FROM amazonlinux:2


# Expose ports for gRPC and REST
EXPOSE 8500 8501

ENV MODEL_BASE_PATH=/models \
    MODEL_NAME=model

RUN echo $'[neuron] \n\
name=Neuron YUM Repository \n\
baseurl=https://yum.repos.neuron.amazonaws.com \n\
enabled=1' > /etc/yum.repos.d/neuron.repo

RUN rpm --import https://yum.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB

RUN yum install -y tensorflow-model-server-neuron && rm -rf /var/cache/yum
RUN mkdir -p /root/models/
#copy your model
COPY tf_model/  /root/models/
RUN ls -la /root/models/*

CMD ["/bin/sh", "-c", "/usr/local/bin/tensorflow_model_server_neuron --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=/root/models/${MODEL_NAME}"]
