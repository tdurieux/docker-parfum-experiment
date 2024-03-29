FROM {{ hail_ubuntu_image.image }}

ENV MAKEFLAGS -j2

RUN hail-apt-get-install \
    curl \
    git \
    liblapack3 \
    openjdk-8-jre-headless \
    python3 python3-pip \
    rsync \
    unzip bzip2 zip tar tabix lz4 \
    vim pv
RUN --mount=src=wheel-container.tar,target=/wheel-container.tar \
    tar -xf wheel-container.tar && \
    pip3 install --no-cache-dir -U hail-*-py3-none-any.whl && \
    rm -rf hail-*-py3-none-any.whl && rm wheel-container.tar
RUN hail-pip-install \
      ipython \
      matplotlib \
      numpy \
      scikit-learn \
      dill \
      scipy \
    && rm -rf hail-*-py3-none-any.whl
RUN export SPARK_HOME=$(find_spark_home.py) && \
    curl -f https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-2.2.7.jar \
         >$SPARK_HOME/jars/gcs-connector-hadoop2-2.2.7.jar && \
    mkdir -p $SPARK_HOME/conf && \
    touch $SPARK_HOME/conf/spark-defaults.conf && \
    sed -i $SPARK_HOME/conf/spark-defaults.conf \
        -e 's:spark\.hadoop\.google\.cloud\.auth\.service\.account\.enable.*:spark.hadoop.google.cloud.auth.service.account.enable true:' \
        -e 's:spark\.hadoop\.google\.cloud\.auth\.service\.account\.json\.keyfile.*:spark\.hadoop\.google\.cloud\.auth\.service\.account\.json\.keyfile /gsa-key/key.json:'
# source: https://cloud.google.com/storage/docs/gsutil_install#linux
RUN curl -f https://sdk.cloud.google.com | bash && \
    find \
      /root/google-cloud-sdk/bin/ \
      -type f -executable \
    | xargs -I % /bin/sh -c 'set -ex ; ln -s ${PWD}/% /usr/local/bin/$(basename %)'
