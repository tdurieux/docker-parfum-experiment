FROM node:alpine
LABEL maintainer="rashley-iqt <rashley@iqt.org>"

RUN apk --no-cache upgrade && \
	apk --no-cache add \
    curl

HEALTHCHECK --interval=15s --timeout=15s \
 CMD curl --silent --fail http://localhost:5000/ || exit 1

COPY . /app
WORKDIR /app

RUN npm i npm@latest -g && npm cache clean --force;
RUN npm cache clean --force
RUN npm ci --no-optional
RUN npm run build
RUN npm i -g serve && npm cache clean --force;

EXPOSE 5000
ENTRYPOINT ["serve"]
CMD ["-s", "build", "-l", "5000"]
