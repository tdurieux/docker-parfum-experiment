FROM webbase

RUN conda install -c conda-forge pylint black --yes

ENV GOOGLE_APPLICATION_CREDENTIALS ./google-creds.json

CMD python manage.py runserver 0.0.0.0:$PORT