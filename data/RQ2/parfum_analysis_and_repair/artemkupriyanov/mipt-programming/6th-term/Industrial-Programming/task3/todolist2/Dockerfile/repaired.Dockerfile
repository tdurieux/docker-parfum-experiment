FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /code/django & mkdir /code/react & mkdir /npm
WORKDIR /npm
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install create-react-app react react-scripts mini-signals && npm cache clean --force;
WORKDIR /code
ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000:8000
EXPOSE 3000:3000
ENTRYPOINT bash init.sh