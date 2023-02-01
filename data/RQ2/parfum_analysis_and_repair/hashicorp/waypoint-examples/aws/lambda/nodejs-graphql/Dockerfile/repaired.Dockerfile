###########
# Builder #
###########
FROM public.ecr.aws/lambda/nodejs:14 as BUILDER

WORKDIR /var/task
COPY index.js package*.json ./

RUN npm install npm@latest -g && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm prune --production

###########
# Runtime #
###########
FROM public.ecr.aws/lambda/nodejs:14

WORKDIR /var/task
COPY --from=BUILDER /var/task ./

CMD [ "index.handler" ]