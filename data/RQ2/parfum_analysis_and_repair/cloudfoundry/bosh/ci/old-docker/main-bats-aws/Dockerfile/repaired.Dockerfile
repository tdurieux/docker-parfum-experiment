FROM bosh/main-ruby-go

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir awscli --upgrade --user
ENV PATH=/root/.local/bin:$PATH
