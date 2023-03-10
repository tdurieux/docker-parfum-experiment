# This Dockerfile is merely used to generate binaries for direct use during
# buildpack runtime.

FROM heroku/cedar

RUN apt-get -qy update && apt-get -y --no-install-recommends install npm nodejs-legacy && rm -rf /var/lib/apt/lists/*;
ENV PATH /app/bin:$PATH
WORKDIR /tmp


# Install Elm
ENV ELM_VERSION 0.18.0

RUN npm install -g elm@${ELM_VERSION} && npm cache clean --force;
RUN mkdir -p /app/.profile.d /app/bin
RUN cp /usr/local/lib/node_modules/elm/Elm-Platform/${ELM_VERSION}/.cabal-sandbox/bin/* /app/bin

# Startup scripts for heroku
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

# AWS upload script
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
ADD upload-to-s3.sh /app/bin/
