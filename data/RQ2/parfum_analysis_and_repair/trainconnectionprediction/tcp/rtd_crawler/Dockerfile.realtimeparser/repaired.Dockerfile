## realtimeparser docker instructions
## build
# DOCKER_BUILDKIT=1 docker build -f rtd_crawler/Dockerfile.realtimeparser . -t realtimeparser
## run
# docker run -v $(pwd)/server_config.py:/mnt/config/config.py -v $(pwd)/cache:/usr/src/app/cache realtimeparser
## push
# docker tag realtimeparser trainconnectionprediction/tcp:realtimeparser
# docker push trainconnectionprediction/tcp:realtimeparser
# kubectl rollout restart deployment.apps/realtimeparser

FROM python:3.9-slim-buster
RUN apt-get update -y && apt-get install --no-install-recommends -y gcc build-essential && rm -rf /var/lib/apt/lists/*;

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src/crawler

RUN pip install --no-cache-dir --upgrade pip
COPY ./rtd_crawler/parser_requirements.txt /usr/src/crawler/parser_requirements.txt
RUN pip install --no-cache-dir -r parser_requirements.txt

COPY ./helpers/ /usr/src/crawler/helpers/
COPY ./database/ /usr/src/crawler/database/
COPY ./rtd_crawler/ /usr/src/crawler/rtd_crawler/

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
RUN addgroup --system --gid 420 tcp && adduser --system --no-create-home --uid 420 --gid 420 tcp
USER tcp

CMD ["python", "rtd_crawler/realtimeparser.py", "--parse_continues"]