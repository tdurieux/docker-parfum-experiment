FROM python:3.9.7

WORKDIR /mnt

VOLUME /mnt

COPY requirements.txt ./

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3-enchant && \
    apt-get install -y --no-install-recommends texlive-xetex && \
    apt-get install --no-install-recommends -y texlive-fonts-recommended && \
    pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["make"]

EXPOSE 8080