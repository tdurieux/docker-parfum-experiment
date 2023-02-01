FROM tensorflow/tensorflow:latest-devel

MAINTAINER Bowei Liu <liubowei@gmail.com>

WORKDIR /root

RUN apt-get update && apt-get install -y --no-install-recommends \
        screen \
        tmux \
        vim && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O http://download.tensorflow.org/example_images/flower_photos.tgz && \
    tar xzf flower_photos.tgz && rm flower_photos.tgz

WORKDIR /tensorflow

RUN bazel build tensorflow/examples/image_retraining:retrain \
                tensorflow/examples/image_retraining:label_image

RUN bazel-bin/tensorflow/examples/image_retraining/retrain \
        --image_dir "$HOME"/flower_photos \
        --how_many_training_steps=200

WORKDIR /root


RUN pip install --no-cache-dir -U flask twisted

RUN curl -f -sSL https://nodejs.org/dist/v8.9.0/node-v8.9.0-linux-x64.tar.gz | \
    tar xzf - --strip-components=1                                            \
              --exclude="README.md"                                           \
              --exclude="LICENSE"                                             \
              --exclude="ChangeLog"                                           \
              -C "/usr/local"

RUN npm install http-proxy && \
    npm install -g seaport http-server && npm cache clean --force;

# recommend using --net=host, but if not, this exposes at least one port to the host
EXPOSE 12480

COPY . /root/
RUN npm i && npm cache clean --force;
RUN chmod u+x /root/*.sh

CMD /bin/bash



