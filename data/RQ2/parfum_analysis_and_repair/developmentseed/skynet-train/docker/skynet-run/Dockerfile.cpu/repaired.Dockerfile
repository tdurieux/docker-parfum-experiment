FROM developmentseed/caffe-segnet:cpu
ENV DEBIAN_FRONTEND noninteractive
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    sudo apt-get install --no-install-recommends -y nodejs build-essential libagg-dev libpotrace-dev && \
    pip install --no-cache-dir flask && \
    pip install --no-cache-dir mercantile && \
    pip install --no-cache-dir boto3 && \
    pip install --no-cache-dir git+https://github.com/flupke/pypotrace.git@master && rm -rf /var/lib/apt/lists/*;

ADD package.json /workspace/package.json
RUN npm install && npm cache clean --force;
ADD . /workspace
EXPOSE 5000

ENV SKYNET_CPU_ONLY=1
