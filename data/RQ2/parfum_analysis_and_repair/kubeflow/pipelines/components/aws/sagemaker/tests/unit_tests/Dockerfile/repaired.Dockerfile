FROM amazonlinux:2

ENV PYTHONPATH /app

RUN yum update -y \
 && yum install -y -q \
    python3 && rm -rf /var/cache/yum

# requirements.txt is copied separately to preserve cache
COPY ./components/aws/sagemaker/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY ./components/aws/sagemaker/dev_requirements.txt .
RUN pip3 install --no-cache-dir -r dev_requirements.txt

COPY . /app/

WORKDIR /app/components/aws/sagemaker/tests/unit_tests/

ENTRYPOINT [ "bash", "./run_automated_test.sh" ]