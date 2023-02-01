FROM python:slim
LABEL Description="This image is used to generate AI VPN network traffic reports." Vendor="Civilsphere Project" Version="0.1" Maintainer="civilsphere@aic.fel.cvut.cz"
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt update && apt -yq --no-install-recommends install tcpdump tshark wkhtmltopdf && rm -rf /var/lib/apt/lists/*;
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python3", "mod_report.py"]
