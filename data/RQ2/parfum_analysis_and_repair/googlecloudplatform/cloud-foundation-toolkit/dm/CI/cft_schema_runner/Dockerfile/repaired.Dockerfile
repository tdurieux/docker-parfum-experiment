FROM gcr.io/cloud-builders/gcloud

RUN apt-get update
RUN apt-get install --no-install-recommends python-setuptools -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends npm -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir yq
RUN npm install -g ajv-cli && npm cache clean --force;
RUN ln -s /usr/bin/nodejs /usr/bin/node

COPY docker-entrypoint.sh /root/
RUN chmod 777 /root/docker-entrypoint.sh

ENTRYPOINT ["/root/docker-entrypoint.sh"]

CMD []
