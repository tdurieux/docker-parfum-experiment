FROM python:3.9-slim
ENV PYTHONUNBUFFERED 1

RUN apt update && apt-get install --no-install-recommends -y libgdal-dev libffi-dev git curl && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

COPY . /code/

