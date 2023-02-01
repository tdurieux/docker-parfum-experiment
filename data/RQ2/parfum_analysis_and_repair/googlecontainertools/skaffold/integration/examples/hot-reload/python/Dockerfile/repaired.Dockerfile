FROM python:3.9-alpine

RUN pip install --no-cache-dir --upgrade pip

RUN adduser -D python
USER python
WORKDIR /home/python

ARG DEBUG=0
ENV FLASK_DEBUG $DEBUG
ENV FLASK_APP=src/app.py
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]

COPY --chown=python:python requirements.txt .
ENV PATH="/home/python/.local/bin:${PATH}"
RUN pip install --no-cache-dir --user -r requirements.txt

COPY --chown=python:python src src
