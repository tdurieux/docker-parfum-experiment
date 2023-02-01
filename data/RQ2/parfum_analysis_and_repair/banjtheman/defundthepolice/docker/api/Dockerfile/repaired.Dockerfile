FROM python:3.8-slim
WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=true
RUN apt-get  update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
ADD api/api_requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt --no-cache-dir
COPY data /app/data
RUN  apt-get remove -y gcc build-essential&& apt-get autoremove -y && apt-get clean -y
WORKDIR /app
