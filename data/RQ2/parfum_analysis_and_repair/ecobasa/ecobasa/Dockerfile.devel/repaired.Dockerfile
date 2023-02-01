# start from an official image
FROM python:2.7

# getting image ready to compile translations
RUN apt-get update && apt-get install --no-install-recommends -y gettext libgettextpo-dev && rm -rf /var/lib/apt/lists/*;

# arbitrary location choice: you can change the directory
RUN mkdir -p /opt/services/ecobasa
WORKDIR /opt/services/ecobasa

# install our dependencies
COPY ./requirements_production.txt /opt/services/ecobasa/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# copy our project code
# COPY ./ /opt/services/ecobasa/

# RUN cd /opt/services/ecobasa/ecobasa/ && \
#        /opt/services/ecobasa/manage.py compilemessages && \
#        cd -

# expose the port 8000
EXPOSE 8000

# define the default command to run when starting the container
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
