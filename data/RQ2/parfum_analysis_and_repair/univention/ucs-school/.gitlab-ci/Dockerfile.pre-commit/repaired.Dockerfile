FROM python:3.7-slim-buster

RUN apt-get -qq update && \
	apt-get install -y -q --assume-yes --no-install-recommends git python3.7 && \
	apt-get clean && \
	rm -f /var/lib/apt/lists/*_*

ENV PYTHONUNBUFFERED 1
RUN pip install --no-cache-dir pre-commit

RUN addgroup --system pre-commit && \
	adduser --system --ingroup pre-commit --disabled-password pre-commit
USER pre-commit

COPY --chown=pre-commit:pre-commit [".pre-commit-config.yaml", ".black", ".flake8", ".isort.cfg", "/home/pre-commit/"]

RUN git init /tmp/seed && \
	cd /tmp/seed && \
	pre-commit install-hooks --config /home/pre-commit/.pre-commit-config.yaml && \
	rm -rf /tmp/seed

ENTRYPOINT ["pre-commit"]
CMD ["run", "-a"]
