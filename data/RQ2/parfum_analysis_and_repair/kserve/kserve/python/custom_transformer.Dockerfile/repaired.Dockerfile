FROM python:3.7-slim

COPY custom_transformer custom_transformer
COPY kserve kserve

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -e ./kserve
RUN pip install --no-cache-dir -e ./custom_transformer
COPY third_party third_party

RUN useradd kserve -m -u 1000 -d /home/kserve
USER 1000
ENTRYPOINT ["python", "-m", "custom_transformer.model"]
