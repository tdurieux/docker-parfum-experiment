FROM cactus/tests:base
WORKDIR /code
COPY . /code/
RUN yarn install --immutable && yarn cache clean;
CMD ["test:visual"]
