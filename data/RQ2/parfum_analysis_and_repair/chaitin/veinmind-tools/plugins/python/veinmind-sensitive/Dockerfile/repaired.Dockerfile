FROM veinmind/python3:1.1.0-stretch
WORKDIR /tool
ADD . .
RUN pip install --no-cache-dir -r requirements.txt
RUN echo "#!/bin/bash\n\npython scan.py \$*" > /tool/entrypoint.sh && chmod +x /tool/entrypoint.sh
ENTRYPOINT ["/tool/entrypoint.sh"]

