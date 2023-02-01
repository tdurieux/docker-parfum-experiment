FROM python:3.8-slim
WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=true
RUN apt-get  update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt /app/

RUN pip install --no-cache-dir -r /app/requirements.txt --no-cache-dir
RUN  apt-get remove -y gcc build-essential cmake make git openssh-client && apt-get autoremove -y && apt-get clean -y