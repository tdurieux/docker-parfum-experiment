FROM owasp/zap2docker-stable

# change to root user, which is the owner of the directories we need to write to
USER root

RUN apt-get update && apt-get install --no-install-recommends -q -y --fix-missing jq && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir --upgrade zapcli
