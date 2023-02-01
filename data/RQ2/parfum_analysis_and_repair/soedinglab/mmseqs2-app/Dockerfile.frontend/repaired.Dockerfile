FROM node:latest as mmseqs-web-frontend-builder

ARG FRONTEND_APP
ENV FRONTEND_APP=$FRONTEND_APP

RUN apt-get update && apt-get install --no-install-recommends -y build-essential bzip2 fontconfig tar && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/mmseqs-frontend
ADD package.json package-lock.json ./

ENV PYTHONIOENCODING=utf8
RUN npm install && npm cache clean --force;

ADD frontend frontend

RUN npm run frontend

FROM nginx:alpine
LABEL maintainer="Milot Mirdita <milot@mirdita.de>"
COPY --from=mmseqs-web-frontend-builder /opt/mmseqs-frontend/dist /var/www/mmseqs-web

