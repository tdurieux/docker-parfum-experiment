FROM browserless/chrome:latest

# Install the AWS SDK

RUN apt update \
	&& apt install --no-install-recommends -y \
	ca-certificates \
	libnss3-tools \
	ffmpeg \
	aws-sdk \
	&& rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

ENV PREBOOT_CHROME=true
ENV KEEP_ALIVE=true
ENV CHROME_REFRESH_TIME=3600000
ENV MAX_QUEUE_LENGTH=20

EXPOSE 3000/tcp