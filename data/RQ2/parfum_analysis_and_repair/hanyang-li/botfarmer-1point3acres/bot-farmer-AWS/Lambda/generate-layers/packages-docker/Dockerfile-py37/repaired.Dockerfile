FROM lambci/lambda:provided
FROM lambci/lambda-base:build

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.7

RUN rm -rf /var/runtime /var/lang /var/rapid && \
  curl -f https://lambci.s3.amazonaws.com/fs/python3.7.tgz | tar -zx -C /

COPY --from=0 /var/runtime/init /var/rapid/init

RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install boto3


ADD package.sh /
ENTRYPOINT ["/package.sh"]
