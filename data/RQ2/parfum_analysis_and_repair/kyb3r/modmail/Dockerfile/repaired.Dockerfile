FROM python:3.9-slim as py

FROM py as build

RUN apt update && apt install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt /
RUN pip install --no-cache-dir --prefix=/inst -U -r /requirements.txt

FROM py

ENV USING_DOCKER yes
COPY --from=build /inst /usr/local

WORKDIR /modmailbot
CMD ["python", "bot.py"]
COPY . /modmailbot
