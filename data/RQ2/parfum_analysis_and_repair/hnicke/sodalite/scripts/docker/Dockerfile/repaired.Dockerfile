FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
        gpg \
        vim \
        curl \
    && curl -f https://debian.hnicke.de/repo/go | sh \
    && apt-get install --no-install-recommends sodalite -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN echo "source /usr/share/sodalite/shell-integration.sh" >> ~/.bashrc
CMD ["bash", "-c", "apt-get update && apt-get upgrade -y && exec bash"]

