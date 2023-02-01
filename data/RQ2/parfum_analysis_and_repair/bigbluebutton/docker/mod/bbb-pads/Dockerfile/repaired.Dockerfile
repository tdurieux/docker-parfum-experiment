FROM node:14.19.1-bullseye-slim AS builder

COPY ./bbb-pads /bbb-pads
RUN cd /bbb-pads && rm -r .git && npm install --production && npm cache clean --force;


RUN chmod 777 /bbb-pads/config
# ------------------------------

FROM node:14.19.1-bullseye-slim

RUN apt update && apt install --no-install-recommends -y jq moreutils \
    && useradd --uid 2003 --user-group bbb-pads && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /bbb-pads /bbb-pads
USER bbb-pads
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh