{{#amd64}}
FROM jess/remmina
{{/amd64}}

RUN useradd -ms /bin/bash remmina
USER remmina