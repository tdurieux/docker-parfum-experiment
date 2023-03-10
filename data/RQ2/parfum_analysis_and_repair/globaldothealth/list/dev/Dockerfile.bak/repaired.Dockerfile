FROM amazon/aws-cli

COPY ./setup_aws.sh ./
COPY ./batch_queue.json ./
COPY ./iam_role.json ./

ENTRYPOINT [ "./setup_aws.sh" ] 