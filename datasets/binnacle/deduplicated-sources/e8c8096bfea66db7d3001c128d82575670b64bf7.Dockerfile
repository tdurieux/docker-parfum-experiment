FROM bitwarden/server

LABEL com.bitwarden.product="bitwarden"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gosu \
&& rm -rf /var/lib/apt/lists/*

ENV ASPNETCORE_URLS http://+:5000
WORKDIR /app
EXPOSE 5000
COPY ./build .
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
