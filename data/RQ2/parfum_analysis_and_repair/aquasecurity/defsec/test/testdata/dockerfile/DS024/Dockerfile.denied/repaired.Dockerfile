FROM debian:9.13
RUN apt-get update && apt-get dist-upgrade && apt-get -y --no-install-recommends install curl && apt-get clean && rm -rf /var/lib/apt/lists/*;
USER mike
CMD python /usr/src/app/app.py
