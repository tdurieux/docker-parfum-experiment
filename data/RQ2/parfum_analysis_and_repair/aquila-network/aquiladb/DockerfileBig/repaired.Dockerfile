# start a new build stage
FROM ubuntu:latest as builder

# set work directory
ENV ROOT_DIR /home/root
WORKDIR $ROOT_DIR

# install aquiladb
RUN apt update && apt install --no-install-recommends -y curl && \
    curl -f -s -L https://raw.githubusercontent.com/Aquila-Network/AquilaDB/master/install.sh | /bin/bash -s -- -m 0 && rm -rf /var/lib/apt/lists/*;


# start a new runner stage
FROM ubuntu:latest as runner

# set work directory
ENV ROOT_DIR /home/root
WORKDIR $ROOT_DIR

RUN echo "$ROOT_DIR"

# copy required files from builder stage
COPY --from=builder $ROOT_DIR/env $ROOT_DIR/env
COPY --from=builder $ROOT_DIR/adb $ROOT_DIR/adb
COPY --from=builder /ossl /ossl

# preperations
ENV PATH="$ROOT_DIR/env/bin:$PATH"
WORKDIR $ROOT_DIR
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install and start demon
RUN export DEBIAN_FRONTEND=noninteractive && mkdir -p /data && apt update && \
    apt install --no-install-recommends -y python3 libgomp1 libblas-dev liblapack-dev && \
    printf "#!/bin/bash\nsource env/bin/activate && cd adb/src && \
    python3 index.py" > /bin/init.sh && chmod +x /bin/init.sh && rm -rf /var/lib/apt/lists/*;

# expose port
EXPOSE 5001

ENTRYPOINT ["init.sh"]
