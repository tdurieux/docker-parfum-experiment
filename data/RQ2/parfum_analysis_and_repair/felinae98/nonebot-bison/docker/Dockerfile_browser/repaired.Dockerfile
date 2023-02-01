FROM python:3.9
RUN apt-get update && apt-get install --no-install-recommends -y fonts-wqy-microhei chromium && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple
RUN python3 -m pip install poetry && poetry config virtualenvs.create false
WORKDIR /app
COPY ./pyproject.toml ./poetry.lock* /app/
RUN poetry install --no-root --no-dev
ENV BISON_BROWSER=local:/usr/bin/chromium
ADD src /app/src
ADD bot.py /app/
ENV HOST=0.0.0.0
