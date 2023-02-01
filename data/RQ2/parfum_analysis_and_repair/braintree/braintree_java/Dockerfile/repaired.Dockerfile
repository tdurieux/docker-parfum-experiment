FROM dockerhub.braintree.tools/bt/java:8-stretch

RUN apt-get update && apt-get -y --no-install-recommends install --force-yes rake ant ant-optional maven procps && rm -rf /var/lib/apt/lists/*;

WORKDIR /braintree-java
