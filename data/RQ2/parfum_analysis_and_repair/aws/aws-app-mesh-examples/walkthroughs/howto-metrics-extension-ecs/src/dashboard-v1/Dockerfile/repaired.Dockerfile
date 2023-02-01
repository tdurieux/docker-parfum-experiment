FROM public.ecr.aws/lambda/nodejs:14

COPY index.js package*.json ${LAMBDA_TASK_ROOT}/

RUN npm install && npm cache clean --force;

CMD [ "index.handler" ] 
