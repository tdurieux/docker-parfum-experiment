# Build client application
FROM node:10 AS build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY client/package.json /app/package.json

RUN npm install react-scripts@3.0.1 -g --silent && npm cache clean --force;
RUN npm install --silent && npm cache clean --force;

COPY client /app

RUN npm run build

# Build main image
FROM python:3.6

WORKDIR /app

# Use python -u/unbuffered setting
ENV PYTHONUNBUFFERED 1

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install requirements
COPY server/requirements /app/requirements
RUN pip install --no-cache-dir -r requirements/prod.txt

# Must be before static file copies
# https://stackoverflow.com/questions/51115856/docker-failed-to-export-image-failed-to-create-image-failed-to-get-layer
COPY server /app

# NOTE: This needs to be improved, but works for now
COPY --from=build /app/server/core/templates/index.html /app/core/templates/index.html
COPY --from=build /app/server/core/static /app/core/static
COPY --from=build /app/build/assets /app/core/static
COPY --from=build /app/build/favicon.ico /app/core/static
COPY --from=build /app/build/manifest.json /app/core/static
COPY --from=build /app/build/asset-manifest.json /app/core/static
COPY --from=build /app/build/service-worker.js /app/core/static

CMD "scripts/startup.sh"
