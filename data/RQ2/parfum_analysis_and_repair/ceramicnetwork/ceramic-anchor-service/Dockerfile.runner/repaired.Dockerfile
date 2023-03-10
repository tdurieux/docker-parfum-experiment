# Be sure to pass env vars for CAS
FROM cas

ENV CAS_PATH=/cas

# For running on AWS ECS
ENV AWS_REGION=${AWS_REGION}
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_ECS_CLUSTER=${AWS_ECS_CLUSTER}
ENV AWS_ECS_FAMILY=${AWS_ECS_FAMILY}

# Discord notifications about running ECS tasks
ENV DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL}
ENV CLOUDWATCH_LOG_BASE_URL=${CLOUDWATCH_LOG_BASE_URL}

WORKDIR /runner

COPY runner/package*.json runner/*.js ./

RUN npm install && npm cache clean --force;

WORKDIR /

COPY runner.sh .

CMD [ "./runner.sh" ]
