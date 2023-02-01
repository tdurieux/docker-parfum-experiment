FROM python:3

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY src/main/python/cltk/cltkrest.py ./

EXPOSE 80

ENV FLASK_APP cltkrest.py

CMD [ "python", "-m", "flask", "run", "-p", "80", "--host", "0.0.0.0" ]
