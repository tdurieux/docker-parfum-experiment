FROM --platform=$BUILDPLATFORM python:3.8 as builder

WORKDIR /install

RUN apt-get update && apt-get install --no-install-recommends -y rustc && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --prefix=/install -r /requirements.txt

FROM python:3.8-slim

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

CMD ["python", "-m", "binance_trade_bot"]
