FROM node:11.15.0 AS run
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;


FROM run AS build
COPY . /app/
WORKDIR /app/

RUN npm ci
RUN npm run-script lint
RUN npm run-script compile

WORKDIR /app/web
RUN npm ci
RUN npm run build
WORKDIR /app/
RUN npm run-script dist

FROM run
WORKDIR /app
COPY --from=build /app/dist /app/dist
COPY --from=build /app/package*.json /app/
ADD package-lock.json package-lock.json
WORKDIR /app/
RUN npm ci --production
ADD scripts/entrypoint.sh /entrypoint.sh
WORKDIR /app/dist/python
RUN pip3 install --no-cache-dir -r requirements.txt
WORKDIR /app
CMD ["/entrypoint.sh"]
