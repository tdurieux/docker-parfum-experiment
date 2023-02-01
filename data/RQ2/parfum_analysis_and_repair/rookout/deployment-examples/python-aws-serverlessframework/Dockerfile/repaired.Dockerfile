FROM lambci/lambda:build-python3.6 AS builder

WORKDIR /build

ADD . .

RUN pip install --no-cache-dir -r requirements.txt -t .

FROM lambci/lambda:build-nodejs12.x

# install serverless framework
RUN npm install -g serverless && npm cache clean --force;

WORKDIR /app

COPY --from=builder /build /app

RUN sed -i '14s/.*/service: python-aws-serverless-reg-test/' serverless.yml