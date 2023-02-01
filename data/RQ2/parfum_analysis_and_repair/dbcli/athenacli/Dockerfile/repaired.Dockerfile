FROM python:3.7

RUN pip install --no-cache-dir athenacli
RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash athena
USER athena
WORKDIR /home/athena

CMD athenacli