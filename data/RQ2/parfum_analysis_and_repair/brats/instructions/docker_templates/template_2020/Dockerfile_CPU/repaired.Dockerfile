# for a CPU app use this Dockerfile, delete the Dockerfile_CUDA then.
FROM python:3.8-buster

# fill in your info here
LABEL author="chuck@norris.org"
LABEL application="your application name"
LABEL maintainer="chuck@norris.org"
LABEL version="0.0.1"
LABEL status="beta"

# basic
RUN apt-get -y update && apt -y full-upgrade && apt-get -y --no-install-recommends install apt-utils wget git tar build-essential curl nano && rm -rf /var/lib/apt/lists/*;

# install all python requirements
WORKDIR /app
COPY ./requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# copy all files
COPY ./ ./
RUN pip3 install --no-cache-dir -U python-dotenv

ENTRYPOINT [ "python3","-u", "run.py"]
