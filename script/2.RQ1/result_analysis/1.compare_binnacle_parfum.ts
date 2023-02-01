import { join } from "path";
import * as utils from "../../utils";
import ProgressBar from "progress";
import async from "async";
import { readFile, rm } from "fs/promises";
import config from "../../../config";

function distribution(vulnerabilityDistribution) {
  let nbContract = 0;
  let previous = 0;
  let out = "";
  for (const nb in vulnerabilityDistribution) {
    nbContract += vulnerabilityDistribution[nb];
    previous += vulnerabilityDistribution[nb];
    if (nb == "0") {
      out += ` (0, ${previous})`;
      previous = 0;
    } else if (nb == "1") {
      out += ` (1, ${previous})`;
      previous = 0;
    } else if (nb == "2") {
      out += ` (2, ${previous})`;
      previous = 0;
    } else if (nb == "3") {
      out += ` (3, ${previous})`;
      previous = 0;
    } else if (nb == "10") {
      out += ` (4, ${previous})`;
      previous = 0;
    } else if (nb == "20") {
      out += ` (5, ${previous})`;
      previous = 0;
    } else if (nb == "50") {
      out += ` (6, ${previous})`;
      previous = 0;
    }
  }
  out += ` (7, ${previous})`;
  console.log(out);
  return nbContract;
}
(async () => {
  const binnacleViolations = join(
    config.dataFolder,
    "dataset/binnacle/results-github-individual.txt"
  );

  const binnacleVulnerabilityCount = {};
  const binnacleVulnerabilityDistribution = {};
  const binnacleSmellyDockerCount: { [key: string]: number } = {};
  let binnacleTotalSmellyDocker = 0;

  for (const line of (await readFile(binnacleViolations, "utf-8")).split(
    "\n"
  )) {
    if (line.trim().length == 0) continue;
    try {
      const info: {
        all_violations: {
          [key: string]: {
            violations: number;
          };
        };
      } = JSON.parse(line);
      let countViol = 0;
      for (const viol in info.all_violations) {
        binnacleVulnerabilityCount[utils.smellName(viol)] =
          binnacleVulnerabilityCount[utils.smellName(viol)]
            ? binnacleVulnerabilityCount[utils.smellName(viol)] +
              info.all_violations[viol].violations
            : info.all_violations[viol].violations;
        countViol += info.all_violations[viol].violations;

        if (info.all_violations[viol].violations > 0) {
          binnacleSmellyDockerCount[utils.smellName(viol)] =
            binnacleSmellyDockerCount[utils.smellName(viol)]
              ? binnacleSmellyDockerCount[utils.smellName(viol)] + 1
              : 1;
        }
      }

      if (countViol > 0) binnacleTotalSmellyDocker += 1;

      binnacleVulnerabilityDistribution[countViol] =
        binnacleVulnerabilityDistribution[countViol]
          ? binnacleVulnerabilityDistribution[countViol] + 1
          : 1;
    } catch (error) {
      console.log(error);
      console.log(line);
    }
  }

  const violationsFiles = utils.walkSync(
    config.defaultBinnacleAnalysisAndRepairPath
  );

  const bar = new ProgressBar(
    "[:bar] :current/:total :rate/bps :percent :etas :step",
    {
      complete: "=",
      incomplete: " ",
      width: 30,
      total: violationsFiles.length,
    }
  );

  const smellyDockerCount: { [key: string]: number } = {};
  const vulnerabilityCount: { [key: string]: number } = {};
  const vulnerabilityDistribution: { [key: string]: number } = {};
  let totalSmellyDocker = 0;
  async.forEachOfLimit(
    violationsFiles,
    10,
    async (path, _, callback) => {
      const [owner, repo] = path.replace(".json", "").split("/").slice(-2);

      try {
        const info = await utils.readAnalsysiResults(path);
        if (!info.originalSmells) {
          await rm(path);
          return;
        }

        const nbSmell = info.originalSmells.length;
        bar.tick({ step: `${repo} ${nbSmell}` });
        vulnerabilityDistribution[nbSmell] = vulnerabilityDistribution[nbSmell]
          ? vulnerabilityDistribution[nbSmell] + 1
          : 1;

        for (const vul of info.originalSmells) {
          const name = utils.smellName(vul.rule);
          vulnerabilityCount[name] = vulnerabilityCount[name]
            ? vulnerabilityCount[name] + 1
            : 1;
        }
        new Set(
          info.originalSmells.map((vul) => utils.smellName(vul.rule))
        ).forEach((name) => {
          smellyDockerCount[name] = smellyDockerCount[name]
            ? smellyDockerCount[name] + 1
            : 1;
        });

        if (nbSmell > 0) {
          totalSmellyDocker += 1;
        }
      } catch (e) {
        console.error(e);
      } finally {
        callback();
      }
    },
    () => {
      console.log("\n ## Results RQ1 \n");
      const violationNames = Object.keys(binnacleVulnerabilityCount);
      violationNames.sort(
        (a, b) => binnacleVulnerabilityCount[b] - binnacleVulnerabilityCount[a]
      );

      let nbViolation = 0;
      let nbViolationBinnacle = 0;
      let totalDiff = 0;
      let totalDockerDiff = 0;
      for (let name of violationNames) {
        nbViolation += vulnerabilityCount[name] || 0;
        nbViolationBinnacle += binnacleVulnerabilityCount[name];

        const diff =
          vulnerabilityCount[name] - binnacleVulnerabilityCount[name];
        const smellyDockerDiff =
          smellyDockerCount[name] - binnacleSmellyDockerCount[name];

        totalDiff += Math.abs(diff);
        totalDockerDiff += Math.abs(smellyDockerDiff);
        console.log(
          `${name} & \\percent{${
            binnacleVulnerabilityCount[name] || 0
          }}{\\nbViolationsByBinnacle} & \\percent{${
            vulnerabilityCount[name] || 0
          }}{\\nbViolationsByTool} & \\np{${diff}} & \\percent{${
            binnacleSmellyDockerCount[name] || 0
          }}{\\totalSmellyDockerFileByToolInBinnacle} & \\percent{${
            smellyDockerCount[name] || 0
          }}{\\totalSmellyDockerFileByBinnacleInBinnacle} & \\np{${smellyDockerDiff}}\\\\`
        );
      }

      console.log(`\\def\\totalDockerDiff{${totalDockerDiff}}`);
      console.log(
        `\\def\\totalSmellyDockerFileByToolInBinnacle{${totalSmellyDocker}}`
      );
      console.log(
        `\\def\\totalSmellyDockerFileByBinnacleInBinnacle{${binnacleTotalSmellyDocker}}`
      );

      console.log(`\\def\\totalDiff{${totalDiff}}`);
      console.log(`\\def\\nbViolationsByTool{${nbViolation}}`);
      console.log(`\\def\\nbViolationsByBinnacle{${nbViolationBinnacle}}`);
      console.log("Distribution of Smell detected by Binnacle");
      console.log(
        `\\def\\nbDockerfilesBinnacle{${distribution(
          binnacleVulnerabilityDistribution
        )}}`
      );
      console.log("Distribution of Smell detected by Parfum");
      console.log(
        `\\def\\nbDockerfilesByTool{${distribution(vulnerabilityDistribution)}}`
      );
    }
  );
})();
