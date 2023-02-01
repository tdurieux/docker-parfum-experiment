FROM electronuserland/builder:wine as desktop
ARG DAMSELFLY_VERSION
RUN echo Damselfly Desktop version ${DAMSELFLY_VERSION}
RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
COPY . /src
WORKDIR "/src"
RUN yarn install && yarn cache clean;
# RUN yarn version --new-version ${DAMSELFLY_VERSION}
RUN yarn distwin
WORKDIR "/src/dist"
RUN zip /damselfly-win.zip *.*
