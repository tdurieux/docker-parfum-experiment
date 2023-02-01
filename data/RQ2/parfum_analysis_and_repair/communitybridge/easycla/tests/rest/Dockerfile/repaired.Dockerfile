FROM python:3.7-alpine

WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.freeze.txt


CMD pytest --alluredir=allure_result_folder -v
