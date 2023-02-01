# Copyright Jetstack Ltd. See LICENSE for details.
FROM python:3.6-stretch

WORKDIR /site

# ensure python and dependencies are installed
RUN apt-get update && apt-get install --no-install-recommends -y python-enchant wbritish && rm -rf /var/lib/apt/lists/*;

# install sphinx
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p venv/bin && ln -s $(which python) venv/bin/python && touch .venv

ENTRYPOINT ["make"]
CMD ["spelling", "linkcheck", "html"]
