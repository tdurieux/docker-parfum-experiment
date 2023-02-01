FROM python:3.10.0-slim-bullseye
WORKDIR /usr/src/app

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# system dependencies
RUN apt-get update && apt install --no-install-recommends -y git gcc python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


# python dependencies
COPY ./requirements.txt .
COPY . .
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "-u", "main.py"]
