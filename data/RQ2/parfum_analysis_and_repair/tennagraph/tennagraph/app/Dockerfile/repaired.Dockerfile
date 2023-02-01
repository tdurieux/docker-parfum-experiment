FROM python:3.6-slim
ENV PYTHONUNBUFFERED 1

# Installing dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential netcat-openbsd libssl-dev gettext git && rm -rf /var/lib/apt/lists/*;


# Setting up codebase directory
ENV APP_HOME /usr/src/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Install requirements
# ADD requirements.txt $APP_HOME/
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Add current codebase to container
# ADD . $APP_HOME/
COPY . .

# Expose external port
EXPOSE 8000
EXPOSE 5000

# Launch the server
CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000"]
# CMD [ "python", "./your-daemon-or-script.py" ]
