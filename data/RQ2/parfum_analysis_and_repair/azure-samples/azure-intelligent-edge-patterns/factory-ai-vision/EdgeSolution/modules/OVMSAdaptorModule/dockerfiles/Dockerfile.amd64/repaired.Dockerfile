#FROM amd64/python:3.8
FROM python:3.8.6-buster

# Copy AVA extension specific files

RUN mkdir /app

COPY ../app/requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

RUN apt update && apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pillow

COPY ../app/*.py /app/
COPY ../app/cascade/*.py /app/cascade/
COPY ../app/entry.sh /app/

WORKDIR /app/

ENTRYPOINT ["bash", "entry.sh"]
