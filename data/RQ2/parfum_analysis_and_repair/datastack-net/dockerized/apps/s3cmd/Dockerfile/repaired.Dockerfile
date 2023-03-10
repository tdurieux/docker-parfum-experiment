ARG S3CMD_BASE=""
FROM $S3CMD_BASE
ARG S3CMD_VERSION=""

RUN pip install --no-cache-dir s3cmd==$S3CMD_VERSION

ENTRYPOINT ["s3cmd"]
