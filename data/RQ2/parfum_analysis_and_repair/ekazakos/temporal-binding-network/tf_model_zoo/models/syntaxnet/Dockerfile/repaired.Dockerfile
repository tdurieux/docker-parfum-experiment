FROM java:8

ENV SYNTAXNETDIR=/opt/tensorflow PATH=$PATH:/root/bin

RUN mkdir -p $SYNTAXNETDIR \
    && cd $SYNTAXNETDIR \
    && apt-get update \
    && apt-get install --no-install-recommends git zlib1g-dev file swig python2.7 python-dev python-pip python-mock -y \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -U protobuf==3.0.0 \
    && pip install --no-cache-dir asciitree \
    && pip install --no-cache-dir numpy \
    && wget https://github.com/bazelbuild/bazel/releases/download/0.3.1/bazel-0.3.1-installer-linux-x86_64.sh \
    && chmod +x bazel-0.3.1-installer-linux-x86_64.sh \
    && ./bazel-0.3.1-installer-linux-x86_64.sh --user \
    && git clone --recursive https://github.com/tensorflow/models.git \
    && cd $SYNTAXNETDIR/models/syntaxnet/tensorflow \
    && echo "\n\n\n\n" | ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN cd $SYNTAXNETDIR/models/syntaxnet \
    && bazel test --genrule_strategy=standalone syntaxnet/... util/utf8/...

WORKDIR $SYNTAXNETDIR/models/syntaxnet

CMD [ "sh", "-c", "echo 'Bob brought the pizza to Alice.' | syntaxnet/demo.sh" ]

# COMMANDS to build and run
# ===============================
# mkdir build && cp Dockerfile build/ && cd build
# docker build -t syntaxnet .
# docker run syntaxnet
