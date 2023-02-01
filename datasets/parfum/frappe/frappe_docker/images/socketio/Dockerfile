FROM alpine/git as builder

ARG FRAPPE_VERSION
ARG FRAPPE_REPO=https://github.com/frappe/frappe
RUN git clone --depth 1 -b ${FRAPPE_VERSION} ${FRAPPE_REPO} /opt/frappe


FROM node:17-alpine

RUN addgroup -S frappe \
    && adduser -S frappe -G frappe
USER frappe

WORKDIR /home/frappe/frappe-bench
RUN mkdir -p sites apps/frappe

COPY --chown=frappe:frappe --from=builder /opt/frappe/socketio.js /opt/frappe/node_utils.js apps/frappe/
COPY --chown=frappe:frappe package.json apps/frappe/

RUN cd apps/frappe \
    && npm install

WORKDIR /home/frappe/frappe-bench/sites

CMD [ "node", "/home/frappe/frappe-bench/apps/frappe/socketio.js" ]
