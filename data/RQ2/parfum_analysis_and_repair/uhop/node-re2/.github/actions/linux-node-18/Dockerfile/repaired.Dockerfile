FROM node:18-buster

RUN apt install -y --no-install-recommends python3 make gcc g++ && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
