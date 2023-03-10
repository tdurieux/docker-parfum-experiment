FROM brimstone/kali:latest

RUN apt update \
 && apt install -y --no-install-recommends \
	burpsuite openjdk-11-jre zaproxy \
 && apt clean \
 && rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;
