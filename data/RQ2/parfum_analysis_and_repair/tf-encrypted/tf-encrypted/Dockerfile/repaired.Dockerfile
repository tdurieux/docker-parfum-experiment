FROM python:3.5-jessie

ARG TF_WHL_URL="https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.9.0-cp35-cp35m-linux_x86_64.whl"

RUN mkdir -p /usr/src/tf-encrypted \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade $TF_WHL_URL && rm -rf /usr/src/tf-encrypted

WORKDIR /usr/src/tf-encrypted

COPY . .
RUN make bootstrap

EXPOSE 4440

ENTRYPOINT ["python", "-u", "bin/serve"]
