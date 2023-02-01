FROM python:3.7.8-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN apk add --no-cache gcc python3-dev musl-dev

COPY nullctf.py .
COPY cogs .
COPY help_info.py .
COPY magic.json .
COPY config_vars.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "nullctf.py"]