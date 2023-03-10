FROM google/cloud-sdk:274.0.1
RUN set -x \
      && apt-get install --no-install-recommends -y default-jre \
      && apt-get install -y --no-install-recommends google-cloud-sdk-pubsub-emulator google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

ENV DATA_DIR=/data
ENV HOST_PORT=0.0.0.0:8080
EXPOSE 8080

CMD ["sh", "-c", "exec gcloud beta emulators pubsub start --project=pgsink --host-port=${HOST_PORT} --data-dir=${DATA_DIR}"]
