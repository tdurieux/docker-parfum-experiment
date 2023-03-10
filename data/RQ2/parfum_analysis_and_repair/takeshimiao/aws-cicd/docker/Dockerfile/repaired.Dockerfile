FROM amazonlinux:2018.03

# Install setuptools + pip
RUN cd /tmp && \
    curl -f https://bootstrap.pypa.io/get-pip.py | python - && \
    python -m pip install --upgrade pip setuptools wheel

RUN pip install --no-cache-dir bottle
RUN pip install --no-cache-dir boto3

WORKDIR /app
COPY app /app


ENV SECRET_NAME mysecret_from_docker
ENV REGION us-east-1_from_docker

ENTRYPOINT ["python", "aws-cicd/api/main.py"]
