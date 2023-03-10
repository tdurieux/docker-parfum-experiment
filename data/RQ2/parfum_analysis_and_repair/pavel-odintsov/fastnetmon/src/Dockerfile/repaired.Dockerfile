FROM ubuntu:22.04

ARG installer_file_name=installer

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y wget && wget https://install.fastnetmon.com/$installer_file_name -Oinstaller && chmod +x installer && ./installer -install_community_edition && rm -rf /var/lib/apt/lists/*;

LABEL org.opencontainers.image.source https://github.com/pavel-odintsov/fastnetmon

CMD /opt/fastnetmon/fastnetmon
