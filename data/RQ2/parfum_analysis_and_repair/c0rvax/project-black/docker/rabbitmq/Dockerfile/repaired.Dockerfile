FROM rabbitmq:3-management
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
EXPOSE 5672 15672
