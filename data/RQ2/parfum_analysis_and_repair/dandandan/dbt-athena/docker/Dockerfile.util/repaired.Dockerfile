FROM openjdk:8-jre

RUN apt-get update && \
  apt-get install --no-install-recommends -yf postgresql-client netcat && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY wait_for_up.bash /bin/wait_for_up
RUN chmod +x /bin/wait_for_up
