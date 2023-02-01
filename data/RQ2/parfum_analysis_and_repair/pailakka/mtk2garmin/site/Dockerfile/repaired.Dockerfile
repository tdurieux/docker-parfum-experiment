FROM python:3


WORKDIR /opt/mtkgarmin-site

RUN apt update && apt install --no-install-recommends -y curl rsync && \
    curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN chmod +x ./generate_site.sh && pip install --no-cache-dir -r requirements.txt

CMD ./generate_site.sh

