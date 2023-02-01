FROM ubuntu:18.04 as builder

COPY . /rafMetrics
WORKDIR /rafMetrics

RUN apt-get clean \
    && apt-get -y update

RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;

RUN npm install -g npm@latest && npm cache clean --force;
RUN npm install --prefix metricsUI/ metricsUI/ && npm cache clean --force;
RUN npm run-script --prefix metricsUI/ build


FROM nginx:1.17
COPY --from=builder /rafMetrics/metricsUI/build/ /usr/share/nginx/html
