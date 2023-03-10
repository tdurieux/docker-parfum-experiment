FROM reach.base

WORKDIR /opt/reach

COPY ./requirements.txt /opt/reach/requirements.extracter.txt

RUN pip install --no-cache-dir -U pip && \
        python3 -m pip install -r /opt/reach/requirements.extracter.txt


COPY ./extract_refs_task.py /opt/reach/extract_refs_task.py
COPY ./refparse /opt/reach/refparse

# Give execution rights to the entrypoint Python script
RUN chmod +x /opt/reach/extract_refs_task.py
