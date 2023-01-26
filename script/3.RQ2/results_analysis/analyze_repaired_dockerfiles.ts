import { join } from "path";
import { msToReadableTime } from "../../utils";
import { writeFileSync } from "fs";
import Yargs from "yargs/yargs";
import config from "../../../config";
import { readAnalsysiResults, smellName, walk } from "../../utils";
import { rm } from "fs/promises";
import { BINNACLE_RULES } from "@tdurieux/docker-parfum";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("repairPath", {
      type: "string",
      default: config.defaultRepairedDockerfileOutputPath,
    })
    .parse();

  const outputAnalysis = {};
  const smellDistribution = {
    binnacle: {},
    parfum: {},
  };
  const repairedSmellDistribution = {
    binnacle: {},
    parfum: {},
  };
  const smellCount = {};
  const smellyDockerCount = {};
  const repairedSmellCount = {};
  const repairedSmellyDockerCount = {};

  const executionTimes = [];

  let nbAnalysis = 0;
  let nbOriginalViolations = 0;
  let nbSmellyRepairedDocker = 0;

  async function analyzeResult(path: string, dataset: "binnacle" | "parfum") {
    let info: Awaited<ReturnType<typeof readAnalsysiResults>> = undefined;
    try {
      info = await readAnalsysiResults(path);
    } catch (error) {
      await rm(path);
      console.error("Invalid JSON file: " + path);
      return;
    }

    if (!info.originalSmells) {
      await rm(path);
      return;
    }
    nbAnalysis++;
    nbOriginalViolations += info.originalSmells.length;

    if (!info.repairedSmells) {
      // if failed to repair, we consider that the original smells are still present
      info.repairedSmells = info.originalSmells;
    }
    if (info.repairedSmells.length > 0) {
      nbSmellyRepairedDocker++;
    }

    executionTimes.push(info.endTime - info.startTime);

    smellDistribution[dataset][info.originalSmells.length] = smellDistribution[
      dataset
    ][info.originalSmells.length]
      ? smellDistribution[dataset][info.originalSmells.length] + 1
      : 1;

    repairedSmellDistribution[dataset][info.repairedSmells.length] =
      repairedSmellDistribution[dataset][info.repairedSmells.length]
        ? repairedSmellDistribution[dataset][info.repairedSmells.length] + 1
        : 1;

    new Set(info.originalSmells.map((v) => smellName(v.rule))).forEach(
      (name: string) => {
        smellyDockerCount[name] = smellyDockerCount[name]
          ? smellyDockerCount[name] + 1
          : 1;
      }
    );

    new Set(info.repairedSmells.map((v) => smellName(v.rule))).forEach(
      (name: string) => {
        repairedSmellyDockerCount[name] = repairedSmellyDockerCount[name]
          ? repairedSmellyDockerCount[name] + 1
          : 1;
      }
    );

    for (const vul of info.originalSmells) {
      smellCount[smellName(vul.rule)] = smellCount[smellName(vul.rule)]
        ? smellCount[smellName(vul.rule)] + 1
        : 1;
    }
    for (const vul of info.repairedSmells) {
      repairedSmellCount[smellName(vul.rule)] = repairedSmellCount[
        smellName(vul.rule)
      ]
        ? repairedSmellCount[smellName(vul.rule)] + 1
        : 1;
    }

    outputAnalysis[path] = {
      file: path,
      repaired_violations: info.repairedSmells.map((v) => v.rule),
      original_violations: info.originalSmells.map((v) => v.rule),
    };
  }
  async function analyzeBinnacleResults() {
    console.log("Analyzing Binnacle results");
    await walk(config.defaultBinnacleAnalysisAndRepairPath, async (path) => {
      if (!path.endsWith(".json")) {
        return;
      }
      await analyzeResult(path, "binnacle");
    });
  }
  async function analyzeParfumResults() {
    console.log("Analyzing Parfum results");
    await walk(argv.repairPath, async (path) => {
      if (!path.endsWith("results.json")) {
        return;
      }
      await analyzeResult(path, "parfum");
    });
  }

  await Promise.all([analyzeBinnacleResults(), analyzeParfumResults()]);

  // await iterateVulnerabilityAnalysis(
  //   async (analysis) => {
  //     const repo_file = analysis.path
  //       .replace(argv.repairPath + "/", "")
  //       .replace("/" + basename(analysis.path), "");
  //     if (!outputAnalysis[repo_file]) {
  //       outputAnalysis[repo_file] = {
  //         file: repo_file,
  //       };
  //     }

  //     let smellD = smellDistribution;
  //     let smellC = smellCount;
  //     let smellDC = smellyDockerCount;
  //     if (analysis.path.endsWith("repaired_violations.json")) {
  //       smellD = repairedSmellDistribution;
  //       smellC = repairedSmellCount;
  //       smellDC = repairedSmellyDockerCount;
  //       outputAnalysis[repo_file].repaired_violations = analysis.violations.map(
  //         (v) => smellName(v.rule.name)
  //       );

  //       if (analysis.violations.length > 0) {
  //         nbSmellyRepairedDocker++;
  //       }
  //       // {
  //       //   // count: analysis.violations.length,
  //       //   types: analysis.violations.map((v) => v.rule.name),
  //       // };
  //       outputAnalysis[repo_file].diff_stat = {};
  //       const diffPath = analysis.path.replace(
  //         "repaired_violations.json",
  //         "repair.patch"
  //       );
  //       if (existsSync(diffPath)) {
  //         const diff = readFileSync(diffPath, "utf8");
  //         diff.split("\n").forEach((line) => {
  //           if (line.startsWith("@@")) {
  //           } else if (line.startsWith("+") && !line.startsWith("+++")) {
  //             outputAnalysis[repo_file].diff_stat.added =
  //               outputAnalysis[repo_file].diff_stat.added || 0;
  //             outputAnalysis[repo_file].diff_stat.added++;
  //           } else if (line.startsWith("-") && !line.startsWith("---")) {
  //             outputAnalysis[repo_file].diff_stat.removed =
  //               outputAnalysis[repo_file].diff_stat.removed || 0;
  //             outputAnalysis[repo_file].diff_stat.removed++;
  //           }
  //         });
  //       }
  //     } else {
  //       outputAnalysis[repo_file].original_violations = analysis.violations.map(
  //         (v) => smellName(v.rule.name)
  //       );
  //       nbOriginalViolations += analysis.violations.length;

  //       // {
  //       //   // count: analysis.violations.length,
  //       //   types: analysis.violations.map((v) => v.rule.name),
  //       // };
  //     }
  //     const nbSmell = analysis.violations.length;
  //     smellD[nbSmell] = smellD[nbSmell] ? smellD[nbSmell] + 1 : 1;

  //     for (const vul of analysis.violations) {
  //       smellC[smellName(vul.rule.name)] = smellC[smellName(vul.rule.name)]
  //         ? smellC[smellName(vul.rule.name)] + 1
  //         : 1;
  //     }
  //     new Set(analysis.violations.map((v) => smellName(v.rule.name))).forEach(
  //       (name) => {
  //         smellDC[name] = smellDC[name] ? smellDC[name] + 1 : 1;
  //       }
  //     );
  //   },
  //   argv.repairPath,
  //   (path) => path.endsWith("violations.json")
  // );

  const smellNames = BINNACLE_RULES.map((v) => smellName(v.name));
  smellNames.sort((a, b) => smellCount[b] - smellCount[a]);

  let nbSmell = 0;
  for (const name of smellNames) {
    nbSmell += repairedSmellCount[name] || 0;
    console.log(
      `${name} & \\percent{${smellCount[name]}}{\\nbSmell} & \\percent{${
        repairedSmellCount[name] || 0
      }}{\\nbSmellAfterRepair} & \\percent{${
        smellyDockerCount[name]
      }}{\\nbTotalDockerfilesWithSmell} & \\percent{${
        repairedSmellyDockerCount[name] || 0
      }}{\\nbTotalRepairedDockerfilesWithSmell} \\\\`
    );
  }

  console.log(
    `\\def\\totalRepairTime{${msToReadableTime(
      executionTimes.reduce((v, t) => v + t, 0)
    )}\\xspace}`
  );
  console.log(
    `\\def\\avgRepairTime{${msToReadableTime(
      executionTimes.reduce((v, t) => v + t, 0) / nbAnalysis
    )}\\xspace}`
  );
  console.log(`\\def\\nbSmell{${nbOriginalViolations}}`);
  console.log(`\\def\\nbSmellAfterRepair{${nbSmell}}`);
  console.log(`\\def\\nbSmellyDockerAfterRepair{${nbSmellyRepairedDocker}}`);

  function generateDistribution(distribution: {
    binnacle: { [x: string]: number };
    parfum: { [x: string]: number };
  }) {
    const nbDockerfile = {
      binnacle: 0,
      parfum: 0,
    };
    const nbDockerfileWithViolations = {
      binnacle: 0,
      parfum: 0,
    };
    for (const dataset in distribution) {
      let previous = 0;
      let out = "";
      for (const nb in distribution[dataset]) {
        nbDockerfile[dataset] += distribution[dataset][nb];
        if (nb != "0") {
          nbDockerfileWithViolations[dataset] += distribution[dataset][nb];
        }
        previous += distribution[dataset][nb];
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
      console.log("% " + dataset + " distribution:");
      console.log(out);
    }
    return { nbDockerfile, nbDockerfileWithViolations };
  }
  console.log("\nSmell distribution before repair");
  const oD = generateDistribution(smellDistribution);
  console.log(
    `\\def\\nbTotalDockerfiles{${
      oD.nbDockerfile.binnacle + oD.nbDockerfile.parfum
    }}`
  );
  console.log(`\\def\\nbBinnacleDockerfiles{${oD.nbDockerfile.binnacle}}`);
  console.log(`\\def\\nbParfumDockerfiles{${oD.nbDockerfile.parfum}}`);
  console.log(
    `\\def\\nbTotalDockerfilesWithSmell{${
      oD.nbDockerfileWithViolations.binnacle +
      oD.nbDockerfileWithViolations.parfum
    }}`
  );
  console.log(
    `\\def\\nbBinnacleDockerfilesWithSmell{${oD.nbDockerfileWithViolations.binnacle}}`
  );
  console.log(
    `\\def\\nbParfumDockerfilesWithSmell{${oD.nbDockerfileWithViolations.parfum}}`
  );

  console.log("\nSmell distribution after repair");
  const rD = generateDistribution(repairedSmellDistribution);

  console.log(
    `\\def\\nbTotalRepairedDockerfiles{${
      rD.nbDockerfile.binnacle + rD.nbDockerfile.parfum
    }}`
  );
  console.log(
    `\\def\\nbBinnacleRepairedDockerfiles{${rD.nbDockerfile.binnacle}}`
  );
  console.log(`\\def\\nbParfumRepairedDockerfiles{${rD.nbDockerfile.parfum}}`);
  console.log(
    `\\def\\nbTotalRepairedDockerfilesWithSmell{${
      rD.nbDockerfileWithViolations.binnacle +
      rD.nbDockerfileWithViolations.parfum
    }}`
  );
  console.log(
    `\\def\\nbBinnacleRepairedDockerfilesWithSmell{${rD.nbDockerfileWithViolations.binnacle}}`
  );
  console.log(
    `\\def\\nbParfumRepairedDockerfilesWithSmell{${rD.nbDockerfileWithViolations.parfum}}`
  );

  setTimeout(() => {
    for (const repo_file of Object.keys(outputAnalysis)) {
      const analysis = outputAnalysis[repo_file];
      if (
        analysis &&
        (!analysis.original_violations ||
          analysis.original_violations.length == 0)
      ) {
        delete outputAnalysis[repo_file];
      }
    }
    writeFileSync(
      join(__dirname, "../../../docs/data/analysis.json"),
      JSON.stringify(Object.values(outputAnalysis))
    );
  }, 10000);
})();
