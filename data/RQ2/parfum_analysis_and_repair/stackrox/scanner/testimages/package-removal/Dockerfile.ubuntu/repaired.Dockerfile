FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get purge -y --auto-remove curl
RUN apt-get remove -y --allow-remove-essential apt
