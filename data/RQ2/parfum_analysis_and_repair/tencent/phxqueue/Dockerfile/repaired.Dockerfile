FROM buildpack-deps

COPY . /phxqueue


RUN apt-get update \
        && apt-get install -y cmake --no-install-recommends \
        && apt-get install --no-install-recommends -y python-pip \
        && pip install --no-cache-dir protobuf \
        && cd /phxqueue \
	&& ./build.sh \
	&& find . -name "*.o" | xargs rm && rm -rf /var/lib/apt/lists/*;

ENV WORK_DIR=/phxqueue

WORKDIR $WORK_DIR

VOLUME $WORK_DIR/data

ENV PATH="$WORK_DIR/bin:$PATH"

#COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

#EXPOSE 5100 5200 5300

