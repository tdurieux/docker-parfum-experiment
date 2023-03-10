FROM registry.access.redhat.com/ubi8/python-38

ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme

COPY app /app
COPY run.sh /app/

WORKDIR /app

RUN if [ ! -z ${nexusHostWithBasicAuth} ]; \
    then \
    pip install --no-cache-dir -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install --no-cache-dir -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r requirements.txt; \
    else pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt; \
    fi && \
    pip check

USER root
RUN chown -R 1001:0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh

USER 1001

CMD ["./run.sh"]
