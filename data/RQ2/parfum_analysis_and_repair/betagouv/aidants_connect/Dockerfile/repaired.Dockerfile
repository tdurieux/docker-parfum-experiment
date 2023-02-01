FROM python AS base
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir honcho
RUN mkdir /app/staticfiles

FROM base AS service
WORKDIR /app
COPY . .
