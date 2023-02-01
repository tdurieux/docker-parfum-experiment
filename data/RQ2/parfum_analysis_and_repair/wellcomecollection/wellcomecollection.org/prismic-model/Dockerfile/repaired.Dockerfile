FROM public.ecr.aws/docker/library/node:14-slim

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY . .

CMD ["true"]