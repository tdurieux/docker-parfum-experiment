FROM python:latest

COPY --chown=root:root provision provision
RUN chmod +x provision

RUN pip3 install --no-cache-dir boto3 mysql.connector pyyaml

WORKDIR /provision

ENTRYPOINT ["python3"]
