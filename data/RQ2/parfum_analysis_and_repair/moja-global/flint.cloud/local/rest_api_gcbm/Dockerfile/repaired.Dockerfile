FROM ghcr.io/moja-global/flint.gcbm:master

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Adding npm for CML Actions
RUN apt-get update && apt-get install --no-install-recommends nodejs npm -y && rm -rf /var/lib/apt/lists/*;
RUN node --version
RUN npm --version

COPY . .

CMD ["gunicorn", "--bind", ":8080", "--workers", "1", "--threads", "8", "--timeout", "0", "app:app"]
