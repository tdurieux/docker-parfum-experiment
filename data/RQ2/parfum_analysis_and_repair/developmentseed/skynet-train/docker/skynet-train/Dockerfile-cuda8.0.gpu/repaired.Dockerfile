FROM developmentseed/caffe-segnet:cuda8
MAINTAINER anand@developmentseed.org

ENV DEBIAN_FRONTEND noninteractive
RUN sudo apt-get update && sudo apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    sudo apt-get install --no-install-recommends -y nodejs build-essential && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir boto3 && \
    pip install --no-cache-dir protobuf && \
    pip install --no-cache-dir cython && \
    pip install --no-cache-dir scikit-image

# bsdmainutils is for 'paste' and 'column' commands, used in plot_training_log
RUN pip install --no-cache-dir awscli && \
    apt-get install --no-install-recommends -y bsdmainutils && rm -rf /var/lib/apt/lists/*;

ADD package.json /workspace/package.json
RUN npm install && npm cache clean --force;

ADD . /workspace
WORKDIR /workspace

# Expose demo server port
EXPOSE 5000

ENTRYPOINT ["python", "-u", "segnet/train"]
