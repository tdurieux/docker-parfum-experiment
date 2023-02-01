FROM python:3.8-slim

RUN mkdir /streamlit

COPY requirements.txt /streamlit

WORKDIR /streamlit

RUN pip install --no-cache-dir -r requirements.txt

COPY . /streamlit

EXPOSE 8501

RUN apt-get update -y && apt-get install --no-install-recommends nodejs npm -y && rm -rf /var/lib/apt/lists/*;

RUN npm i -g nodemon && npm cache clean --force;

COPY ./start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]