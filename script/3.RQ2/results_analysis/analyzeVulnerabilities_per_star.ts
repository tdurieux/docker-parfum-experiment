import { iterateVulnerabilityAnalysis } from "../../utils";

(async () => {
  const results = {};
  await iterateVulnerabilityAnalysis(async (analysis) => {
    if (!analysis.repository) return;
    let group = parseInt(analysis.repository.stargazers + "");
    if (group < 10) group = 10;
    else if (group < 20) group = 20;
    else if (group < 50) group = 50;
    else if (group < 100) group = 100;
    else if (group < 1000) group = 1000;
    else if (group < 10000) group = 10000;
    else if (group < 100000) group = 100000;
    else if (group < 1000000) group = 1000000;
    else if (group < 10000000) group = 10000000;

    if (!results[group]) results[group] = [];
    results[group].push(analysis.violations.length);
  });
  for (let group in results) {
    console.log(group, results[group].length);
    results[group].sort((a, b) => a - b);
    const median = results[group][Math.floor(results[group].length / 2)];
    const sum = results[group].reduce((a, b) => a + b, 0);
    const avg = sum / results[group].length;
    console.log(`${group}: ${avg}, ${median}`);
  }
})();
