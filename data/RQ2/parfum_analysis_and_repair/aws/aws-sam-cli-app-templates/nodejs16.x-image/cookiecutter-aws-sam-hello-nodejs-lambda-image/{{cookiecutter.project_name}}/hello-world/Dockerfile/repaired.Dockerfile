FROM public.ecr.aws/lambda/nodejs:16

COPY app.js package*.json ./

RUN npm install && npm cache clean --force;
# If you are building your code for production, instead include a package-lock.json file on this directory and use:
# RUN npm ci --production

# Command can be overwritten by providing a different command in the template directly.
CMD ["app.lambdaHandler"]
