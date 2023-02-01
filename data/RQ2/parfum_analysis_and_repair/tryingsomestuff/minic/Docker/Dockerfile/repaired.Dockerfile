FROM python:3

WORKDIR /

ADD Client.py /
ADD entry.sh /

RUN pip3 install --no-cache-dir requests
RUN apt-get update && apt-get install -y --no-install-recommends libqtcore4 libqtgui4 && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "./entry.sh" ]

