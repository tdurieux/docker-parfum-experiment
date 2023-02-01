FROM python:3-slim

WORKDIR /balsam

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y lsb-release && \
    apt-get install --no-install-recommends -y gnupg && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y postgresql && \
    apt-get install --no-install-recommends -y libpq-dev && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

COPY balsam/ balsam
COPY requirements/ requirements
COPY tests/ tests
COPY setup.cfg .
COPY setup.py .
COPY Makefile .
COPY pyproject.toml .
COPY entrypoint.sh .

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements/deploy.txt
RUN mkdir /balsam/log

ENTRYPOINT ["/balsam/entrypoint.sh"]
