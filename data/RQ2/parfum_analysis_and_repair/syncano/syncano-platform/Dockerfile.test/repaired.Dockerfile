FROM syncano/platform

USER root
COPY --chown=syncano ./requirements_development.txt /home/syncano/app/
RUN pip install --no-cache-dir -r requirements_development.txt
USER syncano