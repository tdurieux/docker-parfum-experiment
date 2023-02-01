ARG PY_VER
ARG NGINX_VER
FROM python:${PY_VER}-alpine as builder
ARG MKDOCS_VER
COPY . /go/src/github.com/gravitational/force
WORKDIR /go/src/github.com/gravitational/force
RUN apk update && apk upgrade && apk add --no-cache git
RUN echo "mkdocs ver is ${MKDOCS_VER}"
RUN pip install --no-cache-dir mkdocs==${MKDOCS_VER}
RUN pip install --no-cache-dir git+https://github.com/simonrenger/markdown-include-lines.git
RUN mkdocs build

FROM nginx:${NGINX_VER}-alpine
COPY --from=builder /go/src/github.com/gravitational/force/site /usr/share/nginx/html
