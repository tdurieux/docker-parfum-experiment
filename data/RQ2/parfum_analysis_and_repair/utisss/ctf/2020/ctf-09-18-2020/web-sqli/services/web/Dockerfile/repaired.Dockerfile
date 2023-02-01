FROM python:3.8.1-slim-buster

ENV DATABASE_URL postgresql://utctf_prob1:thisisthenonrootpasswordforutctf1@db:5432/utctf_db
ENV FLASK_APP=project/__init__.py

WORKDIR /usr/src/app
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
COPY /requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app/

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
