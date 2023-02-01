FROM python:3.8-slim as base

FROM base as builder

RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        g++ && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix="/install" -r requirements.txt

FROM base
COPY --from=builder /install /usr/local

COPY . .
RUN chmod +x ./loadgen.sh
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        curl && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ./loadgen.sh
