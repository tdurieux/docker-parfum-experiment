FROM coinstacteam/coinstac:ci

EXPOSE 3100
CMD . ./config/.env-ci.sh && cd packages/coinstac-api-server/ && node seed/test-setup.js && npm run start