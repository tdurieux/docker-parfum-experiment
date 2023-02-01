FROM mono:latest

ENV FrameworkPathOverride /usr/lib/mono/4.5/

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl make apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg --install packages-microsoft-prod.deb

RUN apt-get update \
    && apt-get install --no-install-recommends -y dotnet-sdk-2.1 && rm -rf /var/lib/apt/lists/*;

COPY prism/prism/nginx/cert.crt /usr/local/share/ca-certificates/cert.crt
RUN update-ca-certificates

COPY . .

RUN make install
