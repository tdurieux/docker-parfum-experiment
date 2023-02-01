ARG PY_VERSION="3.5"
ARG DIST="slim-stretch"

FROM python:${PY_VERSION}-${DIST}
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:${PY_VERSION}-${DIST}
COPY --from=0 /root/.cache /root/.cache

RUN apt-get update && apt-get install --no-install-recommends curl cmake --yes && rm -rf /var/lib/apt/lists/*;

WORKDIR /cartpole-rl-remote

ADD . .
RUN pip install --no-cache-dir .
RUN rm -rf /root/.cache