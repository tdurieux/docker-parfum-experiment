FROM proactionhq/proaction:0.4.7

LABEL "com.github.actions.name"="Proaction"
LABEL "com.github.actions.description"="Create more reliable, maintainable, and secure GitHub Actions"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="gray-dark"


ENTRYPOINT ["/bin/sh", "-c"]