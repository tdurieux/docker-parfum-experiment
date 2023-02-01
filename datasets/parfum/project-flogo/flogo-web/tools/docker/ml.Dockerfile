ARG RELEASE_VERSION=unstable
ARG TF_VERSION=1.13.1

FROM flogo/flogo-web:$RELEASE_VERSION
ARG RELEASE_VERSION
ARG TF_VERSION
ENV CGO_ENABLED 1

RUN set -ex && apt-get update && apt-get install -y - --no-install-recommends \
    libc6-dev \
    && echo " -- Building from version '$RELEASE_VERSION' --" \
    && curl -L "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-$TF_VERSION.tar.gz" \
        | tar -C "/usr/local" -xz \
    && touch /root/.bashrc \
    && echo "export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib" >> /root/.bashrc \
	  && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" >> /root/.bashrc \
	  && ldconfig \
	  && rm -rf /var/lib/apt/lists/*

RUN cd /flogo-web/local/engines/flogo-web && \
       	flogo install github.com/project-flogo/ml/activity/inference@master
