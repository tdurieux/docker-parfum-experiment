FROM python:3.7-buster
RUN apt update -qq \
  && apt install -y --no-install-recommends \
    python-autopep8 \
    libopenblas-dev \
    liblapack-dev \
    texlive-full \
    gfortran && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
