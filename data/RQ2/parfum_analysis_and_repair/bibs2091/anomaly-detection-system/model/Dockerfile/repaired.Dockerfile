FROM python:3.8-slim-buster

WORKDIR /app

COPY ./ /app/

RUN apt update -qq \
    && apt upgrade -y \
    && apt install --no-install-recommends -y curl gcc g++ \
    && apt autoremove -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r ./requirements.txt


EXPOSE 7777
EXPOSE 5000

ENV TERM=linux
ENV TERMINFO=/usr/share/terminfo

CMD ["python","app.py","--host=0.0.0.0"]
