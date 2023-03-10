FROM ccnmtl/django.base
RUN apt-get update \
 && apt-get install --no-install-recommends python3-urllib3 -y && rm -rf /var/lib/apt/lists/*;
ADD requirements /requirements
ADD wheelhouse /wheelhouse
RUN /ve/bin/pip install --no-index -f /wheelhouse -r /wheelhouse/requirements.txt \
&& rm -rf /wheelhouse
WORKDIR /app
COPY . /app/
#RUN /ve/bin/python manage.py test
EXPOSE 8000
ADD docker-run.sh /run.sh
# ENV APP mediathread
ENTRYPOINT ["/run.sh"]
CMD ["run"]
