FROM python:2.7-slim  
  
RUN pip install "flake8"  
  
ENTRYPOINT ["flake8"]  

