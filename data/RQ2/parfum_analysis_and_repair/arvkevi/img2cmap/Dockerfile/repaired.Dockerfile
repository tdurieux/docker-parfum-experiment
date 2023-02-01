FROM python:3.10-slim
LABEL authors="arvkevi@gmail.com"

EXPOSE 8501

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir streamlit
RUN pip install --no-cache-dir -e .

ENTRYPOINT [ "streamlit", "run"]
CMD ["/app/streamlit/app.py"]
