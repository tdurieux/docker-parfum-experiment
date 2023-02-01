FROM python:3.8-slim
RUN apt-get update && apt-get install --no-install-recommends -yqq git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir ecs-deploy awscli
