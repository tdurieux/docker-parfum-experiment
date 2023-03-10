FROM python:3.8

EXPOSE 8501
COPY . .

# RUN apt-get update
# RUN apt-get -y upgrade
# RUN apt-get -y install --no-install-recommends libxmlsec1-dev pkg-config
# RUN /usr/local/bin/python -m pip install --upgrade pip
# RUN pip install -r requirements.txt

RUN pip install --no-cache-dir streamlit numpy pandas plotly pydeck
RUN pip install --no-cache-dir streamlit-aggrid

# COPY ./app /app
WORKDIR /app

ENTRYPOINT ["streamlit", "run"]
CMD ["app.py"]