FROM tiangolo/uwsgi-nginx-flask:python3.8

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

#CMD [ "/bin/bash" ]
