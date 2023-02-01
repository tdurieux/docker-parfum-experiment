FROM rabbitmq:3.6.16-management

RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
