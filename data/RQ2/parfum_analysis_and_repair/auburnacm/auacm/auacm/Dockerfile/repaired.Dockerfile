FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y libffi-dev python3-pip && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /auacm/requirements.txt
RUN cd /auacm; pip3 install --no-cache-dir -r requirements.txt

ADD . /auacm

EXPOSE 5000

CMD ["python3", "/auacm/run.py"]

# To run:
# $ docker run -d -p 5000:5000 -p 3306:3306 --name auacm -v $(pwd):/auacm auacm
