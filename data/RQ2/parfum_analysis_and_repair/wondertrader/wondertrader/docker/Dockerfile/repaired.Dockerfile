from wondertrader/base

WORKDIR /home/wondertrader/
RUN apt update && apt install --no-install-recommends --reinstall -y ca-certificates && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/wondertrader/wondertrader



