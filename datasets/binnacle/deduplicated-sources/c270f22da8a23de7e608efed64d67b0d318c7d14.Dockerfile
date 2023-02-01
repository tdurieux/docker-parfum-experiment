FROM hyperledger/cello-baseimage:latest

COPY src/operator-dashboard /app
COPY src/operator-dashboard/celery.conf /etc/supervisor/conf.d/
RUN	cd /app/ && \
	pip install -r requirements.txt && \
	rm -rf /tmp/cello

CMD /etc/init.d/supervisor start && bash /app/init_client_secrets.sh && if [ "$DEBUG" = "True" ]; then python dashboard.py ; else gunicorn -w 1 --worker-class eventlet -b 0.0.0.0:8080 dashboard:app ;fi
