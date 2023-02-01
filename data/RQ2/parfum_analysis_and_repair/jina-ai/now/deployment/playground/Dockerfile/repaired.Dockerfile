FROM python:3.9

RUN apt-get update && apt-get -y install

COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . /

# needed to copy custom streamlit index.html file to add tracking
COPY custom_streamlit_index.html /usr/local/lib/python3.9/site-packages/streamlit/static/index.html

EXPOSE 8051

ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["streamlit", "run", "playground.py", "--server.port", "8501"]
