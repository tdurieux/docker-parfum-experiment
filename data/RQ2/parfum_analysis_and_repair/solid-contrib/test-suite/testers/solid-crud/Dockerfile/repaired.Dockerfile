FROM node
RUN apt-get update && apt-get install --no-install-recommends -yq \
  vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/solid/solid-crud-tests /app
WORKDIR /app
RUN git checkout v0.3.0
RUN npm install && npm cache clean --force;
ENV NODE_TLS_REJECT_UNAUTHORIZED 0
CMD npm run jest
