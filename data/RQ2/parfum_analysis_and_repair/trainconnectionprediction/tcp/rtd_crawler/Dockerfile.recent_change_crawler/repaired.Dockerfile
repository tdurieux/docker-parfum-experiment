# # build
# DOCKER_BUILDKIT=1 docker build -f rtd_crawler/Dockerfile.recent_change_crawler . -t recent_change_crawler
# # run
# docker run -v $(pwd)/config.py:/mnt/config/config.py -v $(pwd)/cache:/usr/src/app/cache recent_change_crawler
# # push
# docker tag recent_change_crawler trainconnectionprediction/tcp:recent_change_crawler
# docker push trainconnectionprediction/tcp:recent_change_crawler
# kubectl rollout restart deployment.apps/recent-change-crawler


FROM python:3.9-slim-buster
RUN apt-get update -y && apt-get install --no-install-recommends -y gcc build-essential && rm -rf /var/lib/apt/lists/*;

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src/crawler

RUN pip install --no-cache-dir --upgrade pip
COPY ./rtd_crawler/crawler_requirements.txt /usr/src/crawler/crawler_requirements.txt
RUN pip install --no-cache-dir -r crawler_requirements.txt

COPY ./helpers/ /usr/src/crawler/helpers/
COPY ./database/ /usr/src/crawler/database/
COPY ./rtd_crawler/ /usr/src/crawler/rtd_crawler/

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
RUN addgroup --system --gid 420 tcp && adduser --system --no-create-home --uid 420 --gid 420 tcp
USER tcp

CMD ["python", "rtd_crawler/recent_change_crawler.py"]
