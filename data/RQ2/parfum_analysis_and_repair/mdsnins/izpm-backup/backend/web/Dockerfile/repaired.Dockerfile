FROM ubuntu:20.04

RUN apt update
RUN apt -y --no-install-recommends install ca-certificates python3 tar && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir redis flask requests

RUN mkdir /app/
ADD *.py /app/
ADD page /app/page

ENTRYPOINT ["python3", "/app/index.py"]
