FROM eu.gcr.io/gardener-project/cc/job-image-base:0.71.0
COPY --from=gcr.io/kaniko-project/executor:v1.6.0 /kaniko/executor /kaniko/executor.tmp

COPY . /cc/utils/

RUN pip3 install --no-cache-dir --upgrade \
  pip \
  wheel \
&& pip3 install --no-cache-dir --upgrade \
  --find-links /cc/utils/dist \
  gardener-cicd-libs \
  pycryptodome \
&& pip3 install --no-cache-dir gardener-component-model jsonschema

RUN mv /kaniko/executor.tmp /bin/kaniko
