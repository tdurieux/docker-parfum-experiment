FROM python:3.8.7-buster
MAINTAINER Barry Carey <mcarey66@gmail.com>

VOLUME /src/
COPY sleuth_config.json /src/
COPY redditrepostsleuth/ingestsvc/requirements.txt /src/
ADD redditrepostsleuth /src/redditrepostsleuth/
WORKDIR /src

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    python-dev && pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

CMD ["python", "-u", "/src/redditrepostsleuth/ingestsvc/ingestsvc.py"]