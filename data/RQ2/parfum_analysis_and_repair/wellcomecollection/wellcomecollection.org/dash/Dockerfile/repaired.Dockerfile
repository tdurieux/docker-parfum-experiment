FROM public.ecr.aws/docker/library/node:12-slim

WORKDIR /usr/src/app/webapp

RUN apt-get update && apt-get install --no-install-recommends -y awscli && rm -rf /var/lib/apt/lists/*;

ADD ./webapp /usr/src/app/webapp

RUN yarn && \
    yarn build && \
    yarn export && \
    yarn cache clean

CMD ["true"]
