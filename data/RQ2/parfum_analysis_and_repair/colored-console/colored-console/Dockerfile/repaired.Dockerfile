FROM mono
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl libunwind8 gettext apt-transport-https && \
    curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.gpg && \
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-jessie-prod jessie main" > /etc/apt/sources.list.d/dotnetdev.list' && \
    apt-get update && \
    apt-get install --no-install-recommends -y dotnet-sdk-2.0.0 wget unzip && rm -rf /var/lib/apt/lists/*;
WORKDIR /app