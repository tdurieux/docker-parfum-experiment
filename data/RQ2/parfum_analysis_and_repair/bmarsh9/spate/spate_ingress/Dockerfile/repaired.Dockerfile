# install base
FROM ubuntu

# update the operating system:
RUN apt-get update && apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip libpq-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

# copy the folder to the container:
ADD . /spate_ingress

# Define working directory:
WORKDIR /spate_ingress

# Install the requirements
RUN pip3 install --no-cache-dir -r /spate_ingress/requirements.txt

# default command: run the web server
CMD ["/bin/bash","/spate_ingress/run.sh"]

