FROM jupyterhub/jupyterhub

# Create test user (PAM auth) and install single-user Jupyter
RUN useradd testuser --create-home --shell /bin/bash
RUN echo 'testuser:passwd' | chpasswd
RUN pip install --no-cache-dir jupyter

COPY app ./app
COPY jupyterhub_config.py .
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

CMD ["jupyterhub", "--ip", "0.0.0.0"]
