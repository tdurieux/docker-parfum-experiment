FROM coinstacteam/coinstac:ci

EXPOSE 3200
CMD . ./config/.env-ci.sh && sleep 20 && npm run server-ci