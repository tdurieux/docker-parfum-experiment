ARG PYTHONVERSION
FROM python:${PYTHONVERSION}

RUN pip install --no-cache-dir --upgrade pip

ARG DEBUG=0
ENV FLASK_DEBUG $DEBUG
ENV FLASK_APP=src/app.py
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]

COPY requirements.txt .
ENV PATH="/home/python/.local/bin:${PATH}"
RUN pip install --no-cache-dir -r requirements.txt

COPY src src
