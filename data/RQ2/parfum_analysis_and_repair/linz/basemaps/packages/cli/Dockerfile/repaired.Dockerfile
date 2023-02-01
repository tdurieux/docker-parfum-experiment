FROM osgeo/gdal:ubuntu-small-3.3.0

ENV NODE_ENV=PRODUCTION

WORKDIR /app/

RUN apt-get update
RUN apt-get install --no-install-recommends -y openssl ca-certificates > /dev/null 2>&1 && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install sharp TODO update this when we change sharp versions
RUN npm install sharp@0.30.7 playwright@1.22.2 && npm cache clean --force;
RUN npx playwright install --with-deps

# Install the landing assets
COPY ./basemaps-landing*.tgz /app/
RUN npm install ./basemaps-landing*.tgz && npm cache clean --force;

COPY dist/index.cjs /app/

ENTRYPOINT [ "node", "./index.cjs" ]
