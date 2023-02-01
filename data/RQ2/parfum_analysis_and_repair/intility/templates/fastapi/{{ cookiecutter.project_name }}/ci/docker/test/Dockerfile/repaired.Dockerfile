ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN poetry export --dev -o requirements.txt

RUN pip install --no-cache-dir --no-deps -r requirements.txt
