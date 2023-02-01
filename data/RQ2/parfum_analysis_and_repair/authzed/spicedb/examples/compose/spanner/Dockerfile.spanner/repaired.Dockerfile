FROM google/cloud-sdk:slim

RUN apt-get install --no-install-recommends -y google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

ENV EMULATOR_HOST=""
ENV INSTANCE_NAME=""
ENV PROJECT_ID=""

COPY spanner-init .

CMD ./spanner-init
