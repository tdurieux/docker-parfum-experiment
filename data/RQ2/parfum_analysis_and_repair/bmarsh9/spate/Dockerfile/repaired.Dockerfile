#docker build -t dev .
# install base
FROM ubuntu

# update the operating system:
RUN apt-get update --fix-missing
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip libpq-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# copy the folder to the container:
ADD . /spate

# Define working directory:
WORKDIR /spate

# Install the requirements
RUN pip3 install --no-cache-dir -r /spate/requirements.txt

# expose tcp port 5000
#EXPOSE 5000

# default command: run the web server
CMD ["/bin/bash","run.sh"]
