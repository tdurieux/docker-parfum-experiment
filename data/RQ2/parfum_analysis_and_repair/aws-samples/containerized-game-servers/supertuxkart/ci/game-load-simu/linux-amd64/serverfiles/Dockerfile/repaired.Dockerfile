FROM public.ecr.aws/debian/debian:stable-slim

RUN apt -y --fix-missing update
RUN apt install --no-install-recommends -y curl vim unzip jq && rm -rf /var/lib/apt/lists/*;

# Install and configure psql
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --fix-missing -y postgresql && rm -rf /var/lib/apt/lists/*;

#Install aws cli
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN mkdir /root/.aws
COPY config /root/.aws

#Install kubectl for the simulator pod scaler
RUN apt-get install --no-install-recommends -y apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;
RUN kubectl version --client

ADD appsimulator.sh /appsimulator.sh
RUN chmod +x /appsimulator.sh
