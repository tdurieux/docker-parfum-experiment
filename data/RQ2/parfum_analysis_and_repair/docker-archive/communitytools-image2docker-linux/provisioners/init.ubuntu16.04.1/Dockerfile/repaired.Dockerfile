RUN apt-get update && apt-get install --no-install-recommends -y runit && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["runsvdir","-P","/etc/service"]
STOPSIGNAL SIGHUP
