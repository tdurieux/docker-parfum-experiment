FROM rabbitmq:3.7.5-management
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
EXPOSE 4369 5671 5672 25672 15671 15672