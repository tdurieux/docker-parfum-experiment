FROM ubuntu
RUN apt update -y && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
ADD install.sh /run/install.sh
RUN /run/install.sh
RUN mondoo version