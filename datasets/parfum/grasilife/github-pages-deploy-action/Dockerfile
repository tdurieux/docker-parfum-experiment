FROM node:10

LABEL "com.github.actions.name"="Deploy to GitHub Pages"
LABEL "com.github.actions.description"="This action will handle the building and deploying process of your project to GitHub Pages."
LABEL "com.github.actions.icon"="git-commit"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="http://github.com/grasilife/gh-pages-github-action"
LABEL "homepage"="http://github.com/grasilife/gh-pages-gh-action"
LABEL "maintainer"="grasilife <434543162@qq.com>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
