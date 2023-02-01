FROM python:3-slim

RUN apt-get update && \
	apt-get -y --no-install-recommends install nano git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir plexapi
RUN pip install --no-cache-dir watchdog
RUN pip install --no-cache-dir xmltodict

RUN mkdir -p /app

RUN cd /app/ && git clone https://github.com/arehbein-git/ppTag.git pptag

WORKDIR /app/pptag

CMD [ "/bin/bash","-c","python -u pptag.py" ]
