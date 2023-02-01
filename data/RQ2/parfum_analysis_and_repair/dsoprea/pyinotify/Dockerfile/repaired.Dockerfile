FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir nose

ADD ./ /project

WORKDIR /project

RUN pip3 install --no-cache-dir -e .

CMD python3 -m nose -s -v tests
