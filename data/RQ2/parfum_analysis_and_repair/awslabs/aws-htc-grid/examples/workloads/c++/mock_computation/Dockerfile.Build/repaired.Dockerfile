ARG HTCGRID_ACCOUNT
ARG HTCGRID_REGION
FROM ${HTCGRID_ACCOUNT}.dkr.ecr.${HTCGRID_REGION}.amazonaws.com/ecr-public/lambda/provided:al2
RUN yum install -d1 -y make gcc-c++ zip && rm -rf /var/cache/yum
RUN mkdir -p /app
WORKDIR /app

COPY mock_compute_engine.cpp .

COPY Makefile .

RUN make main
RUN mkdir -p /app/build
ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 jq
RUN chmod a+x ./jq
COPY bootstrap .
RUN zip -9yr lambda.zip .
ENTRYPOINT cp lambda.zip /app/build


