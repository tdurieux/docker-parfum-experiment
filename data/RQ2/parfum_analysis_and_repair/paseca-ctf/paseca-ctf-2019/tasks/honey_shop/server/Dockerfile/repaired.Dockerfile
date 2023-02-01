FROM python:alpine
WORKDIR /
COPY ./app /app
RUN pip install --no-cache-dir -r app/requirements.txt
CMD mkdir /home/shop ; cp app/static/images/* /home/shop ; python app/app.py
