FROM python:3.7

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

ADD ./Gunicorn/guni_frontend.py ./Gunicorn/guni_frontend.py
ADD ./FrontendMicroservice ./FrontendMicroservice

WORKDIR ./FrontendMicroservice

EXPOSE 5000
CMD [ "gunicorn", "-c", "../Gunicorn/guni_frontend.py", "main_frontend:app" ]