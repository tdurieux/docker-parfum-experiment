FROM public.ecr.aws/lambda/nodejs:12-arm64
COPY app.js package*.json $LAMBDA_TASK_ROOT
RUN npm install && npm cache clean --force;
CMD [ "app.lambdaHandler" ]