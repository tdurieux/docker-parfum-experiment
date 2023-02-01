FROM python:3.8

RUN pip install --no-cache-dir catalyst[cv]==22.02
RUN pip install --no-cache-dir catalyst[ml]==22.02

COPY . .