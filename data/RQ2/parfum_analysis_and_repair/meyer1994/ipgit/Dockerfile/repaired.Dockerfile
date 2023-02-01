FROM ipfs/go-ipfs:latest as ipfs
FROM python:3.11.0a7-slim

WORKDIR /app

COPY --from=ipfs /usr/local/bin/ipfs /bin/ipfs

RUN apt update \
    && apt install --no-install-recommends -y git \
    && rm -rf /var/lib/apt/lists/*

ENV PORT=8000

COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./ ./

CMD ipfs daemon --init \
    & uvicorn ipgit:app --host 0.0.0.0 --port ${PORT}
