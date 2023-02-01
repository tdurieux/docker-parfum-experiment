FROM python:3.10

WORKDIR /

RUN apt-get update && apt-get install --assume-yes curl unzip git && apt-get clean all

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
RUN pip install -r requirements.txt
COPY . .


ENTRYPOINT [ "bash", "scripts/entrypoint.sh" ]
