ARG PY_ORG="pypy"
ARG PY_VERSION="3-6"
ARG DIST="slim-stretch"

FROM ${PY_ORG}:${PY_VERSION}-${DIST}
COPY requirements.txt .
RUN apt-get update && apt-get install --no-install-recommends cmake build-essential --yes && pypy3 -m ensurepip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt

FROM ${PY_ORG}:${PY_VERSION}-${DIST}
COPY --from=0 /root/.cache /root/.cache

RUN apt-get update && apt install --no-install-recommends curl cmake --yes && rm -rf /var/lib/apt/lists/*;

WORKDIR /cartpole-rl-remote

ADD . .
RUN pypy3 -m ensurepip && pip install --no-cache-dir .
RUN rm -rf /root/.cache