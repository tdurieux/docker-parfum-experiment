FROM public.ecr.aws/lambda/nodejs:12

COPY app.js package.json ./

RUN npm install && npm cache clean --force;

CMD ["app.lambdaHandler"]
