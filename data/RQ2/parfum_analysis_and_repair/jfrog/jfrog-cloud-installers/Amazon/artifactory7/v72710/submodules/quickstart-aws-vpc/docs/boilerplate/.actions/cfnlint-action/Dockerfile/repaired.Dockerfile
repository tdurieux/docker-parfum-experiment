FROM python:3.8-buster
RUN pip install --no-cache-dir cfn-lint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
