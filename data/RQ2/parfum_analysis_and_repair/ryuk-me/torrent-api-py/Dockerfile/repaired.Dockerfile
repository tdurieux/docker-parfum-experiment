FROM python:3.8
ADD requirements.txt requirements.txt
ADD main.py main.py
ADD okteto-stack.yaml okteto-stack.yaml
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8080
COPY . .
CMD ["python3", "main.py"]