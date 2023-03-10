FROM node:12
RUN mkdir /code
WORKDIR /code
COPY package.json yarn.lock /code/
RUN ["yarn", "install"]
CMD ["yarn", "start"]