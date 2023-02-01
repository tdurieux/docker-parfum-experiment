FROM python:3.8

RUN pip install --no-cache-dir --upgrade pip

COPY kserve kserve
COPY paddleserver paddleserver
COPY third_party third_party

RUN pip install --no-cache-dir -e ./kserve -e

RUN useradd kserve -m -u 1000 -d /home/kserve
USER 1000
ENTRYPOINT ["python", "-m", "paddleserver"]
