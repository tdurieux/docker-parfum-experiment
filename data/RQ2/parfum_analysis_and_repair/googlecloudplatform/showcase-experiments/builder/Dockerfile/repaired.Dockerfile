FROM gcr.io/cloud-builders/gcloud:latest
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update -yq && apt-get upgrade -yq && \
    apt-get install --no-install-recommends -yq curl git nano && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_13.x | bash - && \
    apt-get install --no-install-recommends -yq build-essential nodejs node-gyp && rm -rf /var/lib/apt/lists/*;
RUN npm install -g npm && npm cache clean --force;
RUN npm install -g --save-dev @angular/cli && npm cache clean --force;
RUN npm install -g --save-dev yarn && npm cache clean --force;
RUN npm install --save-dev --unsafe-perm node-sass && npm cache clean --force;
RUN npm install --save-dev @angular-devkit/build-angular && npm cache clean --force;
RUN npm install -g --save-dev parcel-bundler && npm cache clean --force;

ENTRYPOINT ["make"]