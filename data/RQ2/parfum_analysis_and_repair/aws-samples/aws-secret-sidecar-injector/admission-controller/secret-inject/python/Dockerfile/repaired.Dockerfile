FROM ubuntu:16.04

ADD . /

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python-pip python-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "python" ]

CMD [ "admission_controller.py" ]