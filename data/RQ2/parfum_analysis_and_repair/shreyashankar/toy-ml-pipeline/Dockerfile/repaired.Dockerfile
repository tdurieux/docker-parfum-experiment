FROM python:3.8

ARG NUM_CPUS=4
ARG DEBIAN_FRONTEND=noninteractive

# Installing Virtualenv
RUN pip install --no-cache-dir virtualenv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="VIRTUAL_ENV/bin:$PATH"

# Working with Application
ENV WORKDIR=app
COPY ./ /${WORKDIR}
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /${WORKDIR}/requirements.txt
RUN pip install --no-cache-dir -e /${WORKDIR}/.

# Expose port
EXPOSE 5000

# Run the application:
# ENTRYPOINT [ "cd", "/app" ]
CMD ["python", "./app/inference/app.py"]

