FROM python:3.10
ENV PYTHONUNBUFFERED 1

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
&& apt-get update && apt-get install --no-install-recommends -y gettext postgresql-client nodejs \
&& wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -P /usr/bin \
&& chmod +x /usr/bin/wait-for-it.sh && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app
COPY requirements.txt package.json /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt
RUN npm install && npm cache clean --force;
COPY . /usr/src/app/
CMD /bin/sh -c "/usr/bin/wait-for-it.sh db:5432 -- ./app/manage.py migrate && ./app/manage.py loaddata tools/docker/user.json && ./app/manage.py runserver 0.0.0.0:8000"
