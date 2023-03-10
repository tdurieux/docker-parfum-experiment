FROM rust:1.56.0-bullseye AS wasm-builder
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
COPY webrtc-introducer-types /build/webrtc-introducer-types
COPY wraft /build/wraft
WORKDIR /build/wraft
RUN wasm-pack build --release

FROM node:gallium AS js-builder
COPY --from=wasm-builder /build/wraft/pkg /build/pkg
COPY wraft/www /build/www
WORKDIR /build/www
RUN npm install && npm run build && npm cache clean --force;

FROM nginxinc/nginx-unprivileged:1.20.2-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=js-builder /build/www/dist/ /usr/share/nginx/html/
