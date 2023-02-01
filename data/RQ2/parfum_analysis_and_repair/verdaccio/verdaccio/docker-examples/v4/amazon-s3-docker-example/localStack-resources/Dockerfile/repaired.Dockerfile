FROM python:3.7-alpine

ENV AWS_ACCESS_KEY_ID='[something]'
ENV AWS_SECRET_ACCESS_KEY='[something]'
ENV AWS_S3_ENDPOINT='http://localstack-s3:4572'

RUN pip install --no-cache-dir awscli
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]
