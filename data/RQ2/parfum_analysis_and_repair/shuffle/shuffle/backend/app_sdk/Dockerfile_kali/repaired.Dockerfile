FROM kalilinux/kali-rolling as base

FROM base as builder

RUN apt-get update && apt install --no-install-recommends build-essential libffi-dev musl-dev openssl python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y


RUN mkdir /install
WORKDIR /install

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --prefix="/install" -r /requirements.txt

FROM base

COPY --from=builder /install /usr/local
COPY __init__.py /app/walkoff_app_sdk/__init__.py
COPY app_base.py /app/walkoff_app_sdk/app_base.py
