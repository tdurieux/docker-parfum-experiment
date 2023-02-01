ARG HTCGRID_ACCOUNT
ARG HTCGRID_REGION
FROM ${HTCGRID_ACCOUNT}.dkr.ecr.${HTCGRID_REGION}.amazonaws.com/ecr-public/lambda/python:3.8
RUN yum install -d1 -y zip && rm -rf /var/cache/yum
RUN mkdir -p /app
WORKDIR /app
COPY mock_compute_engine.py .
RUN mkdir -p /app/build
RUN zip -9yr lambda.zip .
ENTRYPOINT cp lambda.zip /app/build


