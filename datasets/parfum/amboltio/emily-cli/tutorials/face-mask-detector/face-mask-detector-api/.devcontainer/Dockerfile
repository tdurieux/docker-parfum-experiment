
FROM ambolt/emily:1.1.2-slim

COPY requirements.txt /workspace/requirements.txt
WORKDIR /workspace

# add user with normal permission
RUN adduser --disabled-password --gecos "" emilyuser 
# add user to sudo group
RUN adduser emilyuser sudo
# set no password to sudo group
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# set emilyuser as current user
USER emilyuser

ENV PATH="/home/emilyuser/.local/bin:$PATH"

RUN pip install --disable-pip-version-check -r requirements.txt
