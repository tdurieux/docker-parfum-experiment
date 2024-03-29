FROM openhie/package-base:0.1.0
# Add default instant OpenHIE packages
ADD . .

RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

# install aws cli - for credential fetching
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
