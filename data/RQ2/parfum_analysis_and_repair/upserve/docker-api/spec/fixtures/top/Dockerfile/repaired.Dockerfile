FROM debian:stable
RUN apt-get update && apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;
RUN printf '#! /bin/sh\nwhile true\ndo\ntrue\ndone\n' > /while && chmod +x /while
