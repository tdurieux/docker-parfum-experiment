# install base
FROM ubuntu

# update the operating system:
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip libpq-dev && rm -rf /var/lib/apt/lists/*;

# copy the folder to the container:
ADD . /spate_poller

# Define working directory:
WORKDIR /spate_poller

# Install the requirements
RUN pip3 install --no-cache-dir -r /spate_poller/requirements.txt

# default command: run the web server
CMD ["python3","/spate_poller/app.py"]

