FROM uber/web-base-image:1.0.5@sha256:4e53fd9da9d710a9cee8e7c39c3d6edad110904ffc3cf7b1260b9adedd5ba518

WORKDIR /fusion-react-async

COPY . .

RUN yarn && yarn cache clean;

RUN yarn build-test && yarn cache clean;
