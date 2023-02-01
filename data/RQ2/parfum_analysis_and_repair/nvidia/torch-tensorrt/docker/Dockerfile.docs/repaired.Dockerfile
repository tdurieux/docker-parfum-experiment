FROM nvcr.io/nvidia/tensorrt:22.01-py3

RUN curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list

RUN apt-get update && apt-get install --no-install-recommends -y bazel-5.1.1 clang-format-9 libjpeg9 libjpeg9-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/bazel-5.1.1 /usr/bin/bazel
RUN ln -s $(which clang-format-9) /usr/bin/clang-format

# Workaround for bazel expecting both static and shared versions, we only use shared libraries inside container
RUN cp /usr/lib/x86_64-linux-gnu/libnvinfer.so /usr/lib/x86_64-linux-gnu/libnvinfer_static.a

RUN python3 -m pip install --upgrade pip
COPY ./py/requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Locale is not set by default
RUN apt-get update && apt install --no-install-recommends -y locales ninja-build doxygen pandoc && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY ./docsrc/requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

RUN rm -rf /workspace
WORKDIR /
