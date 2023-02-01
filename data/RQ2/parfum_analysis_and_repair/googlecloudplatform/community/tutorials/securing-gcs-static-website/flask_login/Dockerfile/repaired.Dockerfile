FROM python:3.7
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 4000
ENTRYPOINT [ "python" ]
CMD [ "main.py" ]
