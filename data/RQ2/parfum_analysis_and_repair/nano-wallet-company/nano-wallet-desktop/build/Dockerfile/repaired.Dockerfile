FROM electronuserland/builder:wine-mono

RUN apt-get update -q
RUN apt-get install --no-install-recommends -qy apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qy tzdata fakeroot && rm -rf /var/lib/apt/lists/*;

COPY .yarnclean .
COPY patches/*.patch patches/
COPY package.json .
COPY yarn.lock .

RUN yarn install --frozen-lockfile --non-interactive && yarn cache clean;

COPY . .

ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}

ARG EMBER_ENV
ENV EMBER_ENV ${EMBER_ENV}

ARG ELECTRON_PLATFORM
ENV ELECTRON_PLATFORM ${ELECTRON_PLATFORM}

ARG ELECTRON_ARCH
ENV ELECTRON_ARCH ${ELECTRON_ARCH}

CMD yarn ember electron:make -e "${EMBER_ENV}" -p "${ELECTRON_PLATFORM}" -a "${ELECTRON_ARCH}"
