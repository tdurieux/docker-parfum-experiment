FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3.8 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3.8-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y default-libmysqlclient-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libfreetype-dev libfreetype6 libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y pkg-config && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt