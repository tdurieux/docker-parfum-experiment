FROM python:3.9-bullseye

# setup the workspace
COPY . /workspace
WORKDIR /workspace

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8501

ENTRYPOINT ["streamlit", "run"]
CMD ["frontend.py"]
