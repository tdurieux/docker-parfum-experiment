FROM cypress/base

WORKDIR /it

COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;

COPY . .

ENTRYPOINT [ "yarn" ]
CMD [ "test" ]
