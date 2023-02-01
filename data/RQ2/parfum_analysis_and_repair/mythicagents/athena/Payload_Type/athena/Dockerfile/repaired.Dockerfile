From python:3.8-buster

ARG CA_CERTIFICATE
ARG NPM_REGISTRY
ARG PYPI_INDEX
ARG PYPI_INDEX_URL
ARG DOCKER_REGSITRY_MIRROR
ARG HTTP_PROXY
ARG HTTPS_PROXY

RUN apt update && apt install --no-install-recommends wget nuget -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update; \
  apt-get install --no-install-recommends -y apt-transport-https && \
  apt-get update && \
  apt-get install --no-install-recommends -y dotnet-sdk-6.0 && rm -rf /var/lib/apt/lists/*;

COPY ["requirements.txt", "/requirements.txt"]
RUN pip install --no-cache-dir -r /requirements.txt

ENTRYPOINT ["/Mythic/mythic/payload_service.sh"]