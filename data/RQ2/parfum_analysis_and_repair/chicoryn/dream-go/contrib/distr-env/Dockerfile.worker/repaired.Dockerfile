FROM dream_go/base:latest
FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04
COPY requirements.txt /tmp/requirements.txt
RUN apt-get update -qy --no-upgrade && \
    apt-get install --no-install-recommends -qy --no-upgrade python3 python3-pip gnugo && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# copy the start-up script
COPY --from=0 /app/dream_go /app/dream_go
COPY dg_storage.py /app/dg_storage.py
COPY run_worker.py /app/run_worker.py
COPY google-storage-auth.json /app/google-storage-auth.json

ARG GIT_REV
ENV GOOGLE_APPLICATION_CREDENTIALS /app/google-storage-auth.json
ENV RUST_BACKTRACE full
ENV GIT_REV $GIT_REV

WORKDIR /app
CMD timeout 7200 /app/run_worker.py
