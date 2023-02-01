FROM debian:buster-slim

RUN apt-get update && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*;

COPY example_file /

CMD bash
