FROM birkbeckctp/janeway-base:latest
ADD . /vol/janeway
WORKDIR /vol/janeway
RUN apt-get update
RUN apt-get install --no-install-recommends -y pylint && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt --src /tmp/src
RUN pip3 install --no-cache-dir -r dev-requirements.txt --src /tmp/src
RUN if [ -n "$(ls -A ./lib)" ]; then \
 pip3 install --no-cache-dir -e lib/*; fi
RUN cp src/core/janeway_global_settings.py src/core/settings.py

EXPOSE 8000
STOPSIGNAL SIGINT
ENTRYPOINT ["python", "src/manage.py"]
CMD ["runserver", "0.0.0.0:8000"]
