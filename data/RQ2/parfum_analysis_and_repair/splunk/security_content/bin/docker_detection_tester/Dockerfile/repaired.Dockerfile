FROM ubuntu:18.04

RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev git python-dev unzip python3-pip awscli && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-gitdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

ADD . /app

WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "detection_testing_execution.py"]
CMD ["-b", "automated_detections_testing_2"]
