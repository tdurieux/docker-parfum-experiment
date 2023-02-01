FROM python:3.9.7-slim-buster

# create the app user
RUN addgroup --system app && adduser --system --group app

# create the appropriate directories
ENV HOME=/app
RUN mkdir $HOME
RUN mkdir $HOME/cache
WORKDIR $HOME

# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends netcat && rm -rf /var/lib/apt/lists/*;

# Mac running on M1 chip fix
RUN apt update -y && apt install --no-install-recommends -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3
# M1 fix
RUN pip install --no-cache-dir psycopg2-binary --no-binary psycopg2-binary
RUN pip install --no-cache-dir -r requirements.txt

# copy entrypoint-prod.sh
COPY ./script/entrypoint.sh $HOME

# copy project
COPY . $HOME

# chown all the files to the app user
RUN chown -R app:app $HOME

# change to the app user
USER app

ENTRYPOINT ["bash", "/app/entrypoint.sh"]

