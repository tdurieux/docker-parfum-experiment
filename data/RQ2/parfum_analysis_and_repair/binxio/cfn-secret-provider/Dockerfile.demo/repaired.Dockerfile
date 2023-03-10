FROM docker.io/binxio/ssm-get-parameter AS ssm
FROM alpine
COPY --from=ssm /ssm-get-parameter  /usr/local/bin
RUN apk add --no-cache ca-certificates

ENV STACK_NAME=cfn-secret-provider-demo

ENV API_KEY=ssm:///${STACK_NAME}-api-key
ENV PGPASSWORD=ssm:///${STACK_NAME}/demo/PGPASSWORD

ENV IAM_USER_PASSWORD=ssm:///iam-users/${STACK_NAME}-secret-user/password
ENV AWS_ACCESS_KEY_ID=ssm:///iam-users/${STACK_NAME}-secret-user/aws_access_key_id
ENV AWS_ACCESS_SECRET_KEY=ssm:///iam-users/${STACK_NAME}-secret-user/aws_secret_access_key
ENV SMTP_PASSWORD=ssm:///iam-users/${STACK_NAME}-secret-user/smtp_password
ENV RANDOM_BYTES=ssm:///${STACK_NAME}/demo/random


RUN install -m 0600 -d /root/.ssh && install -m 0600 /dev/null /root/.ssh/id_rsa 
ENV PRIVATE_KEY=ssm:///${STACK_NAME}/demo/private-key?destination=/root/.ssh/id_rsa

ENTRYPOINT [ "/usr/local/bin/ssm-get-parameter" ]
CMD [ "/usr/bin/env" ]