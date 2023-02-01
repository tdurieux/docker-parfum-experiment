FROM python:3.8-slim as builder
RUN pip install --no-cache-dir poetry
COPY pyproject.toml .
COPY poetry.lock .
RUN poetry export --format requirements.txt --output /root/requirements.txt

FROM python:3.8-slim
LABEL org.opencontainers.image.source https://github.com/JuliaRegistries/TagBot
ENV PYTHONPATH /root
RUN apt-get update && apt-get install --no-install-recommends -y git gnupg openssh-client && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /root/requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir --requirement /root/requirements.txt
COPY action.yml /root/action.yml
COPY tagbot /root/tagbot
CMD python -m tagbot.action
