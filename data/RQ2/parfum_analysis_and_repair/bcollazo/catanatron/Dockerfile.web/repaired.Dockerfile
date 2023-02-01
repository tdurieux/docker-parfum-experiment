FROM python:3.8

WORKDIR /app

ENV FLASK_ENV=development
ENV FLASK_APP=catanatron_server/catanatron_server
ENV FLASK_RUN_HOST=0.0.0.0

RUN pip install --no-cache-dir --upgrade pip

COPY . .
RUN pip install --no-cache-dir -e catanatron_core
RUN pip install --no-cache-dir -e catanatron_server
RUN pip install --no-cache-dir -e catanatron_gym
RUN pip install --no-cache-dir -e catanatron_experimental

EXPOSE 5000

CMD flask run
