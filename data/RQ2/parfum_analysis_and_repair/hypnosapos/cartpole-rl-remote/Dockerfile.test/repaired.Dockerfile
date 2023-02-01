ARG PY_VERSION="3.5"
ARG DIST="slim-stretch"

FROM python:${PY_VERSION}-${DIST}
COPY requirement*.txt ./
RUN pip install --no-cache-dir -r requirements.txt -r

FROM python:${PY_VERSION}-${DIST}
COPY --from=0 /root/.cache /root/.cache
COPY --from=0 ./requirement*.txt ./

RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -r requirements.txt -r

WORKDIR /cartpole-rl-remote
ADD . .
RUN rm -rf /root/.cache
