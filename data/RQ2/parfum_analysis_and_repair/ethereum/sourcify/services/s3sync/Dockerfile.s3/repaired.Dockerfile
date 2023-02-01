FROM ubuntu:18.04
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y cron curl unzip && rm -rf /var/lib/apt/lists/*;
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
ADD ./login_sync_s3.sh ./login_sync_s3.sh
ADD ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ./entrypoint.sh
