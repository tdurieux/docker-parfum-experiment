FROM python:3.7
WORKDIR /home
EXPOSE 8000
ADD server.py server.py
CMD cd public && python ../server.py
