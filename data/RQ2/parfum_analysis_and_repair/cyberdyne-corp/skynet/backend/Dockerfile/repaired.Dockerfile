FROM java:7

RUN apt-get update && apt-get install --no-install-recommends -y httpie jq && rm -rf /var/lib/apt/lists/*;

COPY scripts/health-check.sh /tmp/health-check.sh
RUN chmod +x /tmp/health-check.sh

ADD https://github.com/cyberdyne-corp/skynet-backend/releases/download/0.0.3/demo-0.0.3.jar /tmp/backend.jar

EXPOSE 8080 8081
