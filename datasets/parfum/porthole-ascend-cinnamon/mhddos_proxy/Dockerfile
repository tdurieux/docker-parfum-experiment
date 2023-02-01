FROM --platform=$TARGETPLATFORM python:3.10-slim as builder

RUN apt-get update && apt-get -y install --no-install-recommends gcc python3-dev
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./requirements.txt .
RUN pip install --no-cache-dir -U pip wheel && pip install --no-cache-dir -r requirements.txt

# Runtime
FROM --platform=$TARGETPLATFORM python:3.10-slim
RUN apt-get update && apt-get -y install --no-install-recommends git

COPY --from=builder	/opt/venv /opt/venv
ENV IS_DOCKER=1 PATH="/opt/venv/bin:$PATH"

RUN git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy.git
WORKDIR mhddos_proxy

ENTRYPOINT ["./runner.sh", "python3"]
