FROM ubuntu:20.04

WORKDIR /

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes python3.10 python3-pip curl unzip git && apt-get clean all && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes wget && apt-get clean all && rm -rf /var/lib/apt/lists/*;
RUN bash -c 'if [ "$(uname -m)" == "aarch64" ]; \
    then \
      arch=arm64; \
    else \
      arch=amd64; \
    fi; \
    wget https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-${arch}.tar.gz && tar -zxvf terraform-docs-v0.16.0-linux-${arch}.tar.gz && chmod +x terraform-docs && mv terraform-docs /usr/local/bin/ && rm terraform-docs-v0.16.0-linux-${arch}.tar.gz'

RUN bash -c 'if [ "$(uname -m)" == "aarch64" ]; \
    then \
      arch=arm64; \
    else \
      arch=amd64; \
    fi; \
    wget https://github.com/aquasecurity/tfsec/releases/download/v1.26.0/tfsec-linux-${arch} -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec'

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --proxy=$http_proxy -r requirements.txt


ENTRYPOINT [ "bash", "scripts/entrypoint.sh" ]

RUN apt-get update
RUN apt-get update && \
    apt-get install --no-install-recommends -y fonts-liberation xdg-utils \
                       software-properties-common curl unzip wget \
                       xvfb && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;


# Install firefox and geckodriver
RUN apt-get update && apt-get install --no-install-recommends -y firefox firefox-geckodriver && apt-get clean all && rm -rf /var/lib/apt/lists/*;

COPY requirements-dev.txt .
RUN pip install --no-cache-dir --proxy=$http_proxy -r requirements-dev.txt

COPY . .

ENTRYPOINT [""]
