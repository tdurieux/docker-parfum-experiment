FROM alexellis2/python-gpio-flask:v6
WORKDIR /root/

RUN sudo pip install --no-cache-dir redis

ADD ./js/ ./js/
ADD ./*.py ./
ADD ./templates/ ./templates/
EXPOSE 5000

CMD ["python", "app.py"]
