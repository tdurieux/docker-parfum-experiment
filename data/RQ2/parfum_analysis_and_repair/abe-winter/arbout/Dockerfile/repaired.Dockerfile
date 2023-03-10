FROM python:3.7.6

WORKDIR /arbout

# deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY dev-requirements.txt .
RUN pip install --no-cache-dir -r dev-requirements.txt

# files
COPY lib lib/
COPY test test/
COPY mypy.ini .
COPY .pylintrc .
COPY app.py .
