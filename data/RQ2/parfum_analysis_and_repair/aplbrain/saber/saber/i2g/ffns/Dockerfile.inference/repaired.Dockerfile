FROM ffn-base

LABEL maintainer="Jordan Matelsky <jordan.matelsky@jhuapl.edu>"

RUN apt-get install --no-install-recommends -yqq \
    python3-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR "ffn"
COPY ./inference/config_template.pbtxt .
COPY ./inference/get-latest-checkpoint .
COPY ./inference/npy2h5.py .
COPY ./inference/driver.py .
COPY ./model /model
RUN mkdir /data
RUN mkdir /latest-model
RUN export LATEST=`./get-latest-checkpoint`
RUN cp /model/model.ckpt-$LATEST* /latest-model
ENTRYPOINT ["python", "driver.py"]
