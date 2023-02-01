FROM lambci/lambda:build-python3.7

ENV VERSION="1.16.8/2020-04-16"

COPY . .

RUN mkdir -p bin/ && \
    curl -o bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/${VERSION}/bin/linux/amd64/kubectl && \
    curl -o bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${VERSION}/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x bin/kubectl && \
    chmod +x bin/aws-iam-authenticator && \
    rm -rf linux-amd64 Dockerfile && \
    find . -exec touch -t 202007010000.00 {} + && \
    zip -X -r lambda.zip ./

CMD mkdir -p /output/ && mv lambda.zip /output/
