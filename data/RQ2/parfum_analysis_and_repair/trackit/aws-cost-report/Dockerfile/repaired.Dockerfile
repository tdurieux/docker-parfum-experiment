FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends jq python3-pip curl -y && rm -rf /var/lib/apt/lists/*;

COPY . /root/aws-cost-report
WORKDIR /root/aws-cost-report
RUN pip3 install --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED=0

ENTRYPOINT ["/root/aws-cost-report/run.py"]
