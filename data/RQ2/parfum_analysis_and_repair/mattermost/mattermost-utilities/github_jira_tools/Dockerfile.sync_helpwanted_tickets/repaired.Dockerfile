FROM python:3

WORKDIR /usr/src/app

COPY *.py requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ENV EXTRA_ARGS= GITHUB_TOKEN= JIRA_TOKEN= JIRA_USERNAME= WEBHOOK_URL=

CMD ["sh", "-c", "python sync_helpwanted_tickets.py --webhook-url $WEBHOOK_URL --jira-token $JIRA_TOKEN --jira-username $JIRA_USERNAME --github-token $GITHUB_TOKEN $EXTRA_ARGS"]