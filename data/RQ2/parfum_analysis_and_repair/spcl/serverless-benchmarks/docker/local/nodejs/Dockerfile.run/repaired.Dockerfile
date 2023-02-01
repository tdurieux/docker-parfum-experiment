ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN deps=''\
  && apt-get update\
  && apt-get install -y --no-install-recommends curl net-tools gosu python3 sudo ${deps} \
  && apt-get purge -y --auto-remove ${deps} && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /sebs
RUN cd /sebs/ && npm install -g uuid strftime express minio && npm cache clean --force;
# NODE_PATH=$(npm root --quiet -g)
# https://github.com/moby/moby/issues/29110
ENV NODE_PATH=/usr/local/lib/node_modules

COPY docker/local/*.py /sebs/
COPY docker/local/run.sh /sebs/
COPY docker/local/nodejs/*.js /sebs/
COPY docker/local/nodejs/run_server.sh /sebs/
COPY docker/local/nodejs/timeit.sh /sebs/
COPY docker/local/nodejs/runners.json /sebs/
COPY docker/local/nodejs/package.json /sebs/

COPY docker/local/entrypoint.sh /sebs/entrypoint.sh
RUN chmod +x /sebs/entrypoint.sh
RUN chmod +x /sebs/run.sh

ENTRYPOINT ["/sebs/entrypoint.sh"]
