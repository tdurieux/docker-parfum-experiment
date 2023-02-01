FROM python

ENV PYTHONUNBUFFERED True

COPY db_assessment /db_assessment
COPY *requirements.txt /db_assessment/

WORKDIR /db_assessment

RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r api-requirements.txt

ENV FLASK_APP=api.py


ENTRYPOINT [ "python", "-m", "flask", "run", "-h", "0.0.0.0", "-p", "8080" ]