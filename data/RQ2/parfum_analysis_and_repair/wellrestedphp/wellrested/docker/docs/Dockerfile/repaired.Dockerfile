FROM python:3-jessie

RUN pip install --no-cache-dir sphinx sphinx_rtd_theme

WORKDIR /usr/local/src/wellrested

CMD ["make", "html", "-C", "docs"]