FROM rabbitmq:3-management
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
EXPOSE 4369 5671 5672 25672 15671 15672