FROM python:3.7-alpine
RUN pip install --no-cache-dir tqdm requests

WORKDIR /app
COPY ./Docker/wass_runall.py /app/wass_runall.py

CMD ["python", "wass_runall.py"]

