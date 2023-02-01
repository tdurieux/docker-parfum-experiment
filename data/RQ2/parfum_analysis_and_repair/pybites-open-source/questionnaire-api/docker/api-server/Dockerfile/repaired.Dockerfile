FROM ubuntu

LABEL maintainer="@code-monk08"

# update
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

# make a local directory
RUN mkdir /opt/opentrivia

# set "opentrivia" as the working directory
# from which CMD, RUN, ADD references
WORKDIR /opt/opentrivia

# copy requirements.txt to /opt/opentrivia
ADD ./requirements.txt .

# pip install the local requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# now copy all the files in this directory to /code
ADD . .

# Set environment varibles
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Listen to port 80 at runtime
EXPOSE 5000

# Define our command to be run when launching the container
CMD ["flask", "run", "--host", "0.0.0.0"]
