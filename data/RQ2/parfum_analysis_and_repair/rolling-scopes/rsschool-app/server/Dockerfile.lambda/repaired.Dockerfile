FROM node:14-bullseye-slim as builder

WORKDIR /container_out

COPY tsconfig.json tsconfig.json
COPY .env .env
COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm ci --production --no-optional

COPY lambda /container_out
COPY dist /container_out

# Lambda Container
FROM public.ecr.aws/lambda/nodejs:14

ENV NODE_ENV production
ENV TZ utc

WORKDIR /var/task

COPY --from=builder /container_out .

CMD [ "app.handler" ]