FROM python:3.9-buster

RUN pip install --no-cache-dir -U cython chardet nose

RUN git clone https://github.com/PyYoshi/cChardet.git /usr/local/src/cChardet
