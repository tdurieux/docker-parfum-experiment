# set base image (host OS)
FROM python:3.8

# set the working directory in the container
WORKDIR /ubotindo/

RUN apt -qq update && apt -qq upgrade
RUN apt -qq install -y --no-install-recommends \
    curl \
    git \
    gnupg2 \
    wget \


COPY requirements.txt . && rm -rf /var/lib/apt/lists/*;

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# copy the content of the local src directory to the working directory
COPY . .

# command to run on container start
CMD [ "bash", "./start" ]
