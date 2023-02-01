FROM public.ecr.aws/docker/library/node:16.13.2-stretch-slim
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.1 /opt/extensions/lambda-adapter /opt/extensions/lambda-adapter
EXPOSE 8080
WORKDIR "/var/task"
ADD src/package.json /var/task/package.json
ADD src/package-lock.json /var/task/package-lock.json
RUN npm install --production
ADD src/ /var/task
CMD ["node", "index.js"]
