FROM ubuntu

WORKDIR /opt/publisher
ADD . .

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r requirements.txt


RUN chmod +x publish.sh && chmod +x publish.sh

