FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y git python-dev python-pip -f && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests dnspython

COPY wait_for_idx_build_complete.py /wait_for_idx_build_complete.py

ENTRYPOINT ["python", "/wait_for_idx_build_complete.py"]