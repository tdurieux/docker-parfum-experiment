FROM python:3.7-slim

RUN apt-get update && apt-get -y --no-install-recommends install git jq && rm -rf /var/lib/apt/lists/*;

COPY duplicate_code_detection.py requirements.txt run_action.py entrypoint.sh /action/

RUN pip3 install --no-cache-dir -r /action/requirements.txt requests && \
    python3 -c "import nltk; nltk.download('punkt')" && \
    ln -s /root/nltk_data /usr/local/nltk_data

ENTRYPOINT ["/action/entrypoint.sh"]
