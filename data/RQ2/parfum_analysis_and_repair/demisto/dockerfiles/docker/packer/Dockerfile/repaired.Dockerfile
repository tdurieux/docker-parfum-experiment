FROM demisto/python3-deb:3.9.1.14969

RUN apt-get update

RUN apt-get install --no-install-recommends curl jq unzip openssh-client -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -so packer.zip $( curl -f -sk https://www.packer.io/downloads.html | grep -oE https://releases\.hashicorp\.com/packer/\[0-9.\]\{5\}/packer_\[0-9.\]\{5\}_linux_amd64\.zip)

RUN unzip packer.zip

RUN mv packer /usr/bin/

RUN rm -f packer.zip

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Instaling the gsutil
RUN apt-get update -y \
  && apt-get install --no-install-recommends apt-transport-https ca-certificates gnupg=2.2.12-1+deb10u1 gpgv=2.2.12-1+deb10u1 -y --allow-downgrades \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
  && apt-get update && apt-get install --no-install-recommends google-cloud-sdk -y \
  && gcloud --version \
  && gsutil --version && rm -rf /var/lib/apt/lists/*;
