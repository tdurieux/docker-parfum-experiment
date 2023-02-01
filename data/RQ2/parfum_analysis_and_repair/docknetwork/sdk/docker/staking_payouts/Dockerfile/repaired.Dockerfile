FROM node:14-stretch AS builder
WORKDIR /usr/app

COPY . .

RUN yarn
RUN yarn build-scripts

FROM public.ecr.aws/lambda/nodejs:14

COPY --from=builder [ "/usr/app/build/scripts/staking_payouts.js", "/usr/app/yarn.lock", "/usr/app/package.json", "./" ]

RUN npm i -g yarn && npm cache clean --force;
RUN yarn

CMD [ "staking_payouts.handler" ]
