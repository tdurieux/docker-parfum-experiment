FROM python:3.8.1

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcairo-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

COPY package.json /usr/src/app/
RUN npm install --prefix /usr/src/app/ && npm cache clean --force;

COPY requirements.txt /usr/src/app
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

COPY . /usr/src/app
WORKDIR /usr/src/app
RUN npm run-script build-jobs

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
