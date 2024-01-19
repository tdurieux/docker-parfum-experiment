import { readFile, readdir } from "fs/promises";
import { join } from "path";
import {
  SIZE_RULES,
  bytesToSize,
  latexBytesToSize,
  latexPercent,
  msToReadableTime,
  percent,
  smellName,
} from "../../utils";
import Yargs from "yargs/yargs";
import config from "../../../config";
import { existsSync } from "fs";
import { RepositoryAnalysisResult } from "../../3.RQ2/repair_repository_dockerfile";
import { parseDocker } from "@tdurieux/dinghy";
import { Matcher } from "@tdurieux/docker-parfum";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("resultPath", {
      type: "string",
      demandOption: false,
      alias: "p",
      default: config.defaultBuildDockerfileOutputPath,
    })
    .option("compression-ratio", {
      type: "number",
      demandOption: false,
      alias: "c",
      default: 3.2,
    })
    .parse();

  const SMELL_NAMES = SIZE_RULES.map((r) => r.name);

  let nbFailedRepair = 0;
  let nbRepair = 0;
  let nbSmell = 0;
  let nbSmellInRepaired = 0;
  let totalSizeDifference = 0;
  let totalSize = 0;
  let totalTime = 0;
  const sizeDifferences: number[] = [];
  const sizeRatioDifferences: number[] = [];
  let totalPull: number = 0;
  let totalPullWeek: number = 0;
  let totalSavedWeek: number = 0;
  let nbDockerHub = 0;

  let nbSmellInDockerHub = 0;
  let nbRepairedSmellInDockerHub = 0;
  let totalDockerHubSizeDifference = 0;

  const sizeDifferencesPerSmell: { [key: string]: number[] } = {};
  const sizeRatioDifferencesPerSmell: { [key: string]: number[] } = {};
  const totalSizePerSmell: { [key: string]: number[] } = {};
  const pullPerRule: { [key: string]: number[] } = {};
  const downloadPerWeekPerRule: { [key: string]: number[] } = {};
  const downloadSavedPerWeekPerRule: { [key: string]: number[] } = {};

  const owners = await readdir(argv.resultPath);
  for (const owner of owners) {
    const repos = await readdir(join(argv.resultPath, owner));
    for (const repoFile of repos) {
      try {
        const results = JSON.parse(
          await readFile(join(argv.resultPath, owner, repoFile), "utf-8")
        ) as RepositoryAnalysisResult;
        const repo = repoFile.replace(".json", "");
        const name = `${owner}/${repo}`;
        if (
          !results.repair ||
          !results.repairedBuild ||
          results.repair.violations.length === 0
        )
          continue;
        const smellNames = new Set<string>(
          results.repair.violations
            .map((v) => smellName(v.name))
            .filter((v) => SMELL_NAMES.includes(v))
        );
        if (smellNames.size === 0) continue;
        nbRepair++;
        totalTime += results.endTime - results.startTime;
        if (results.repairedBuild.error) {
          nbFailedRepair++;
          continue;
        }
        nbSmell += results.repair.violations.filter((v) =>
          SMELL_NAMES.includes(smellName(v.name))
        ).length;
        let ast = null;
        try {
          ast = parseDocker(results.repair.repairedDockerfile);
        } catch (error) {
          if (error.ast) {
            ast = error.ast;
          }
        }
        const violations = new Matcher(ast).matchAll(SIZE_RULES);
        const nbSmellInFile = results.repair.violations.filter((v) =>
          SMELL_NAMES.includes(smellName(v.name))
        ).length;
        nbSmell += nbSmellInFile;
        nbSmellInRepaired += violations.length;
        const originalBuild = results.originalBuild;
        const repairedBuild = results.repairedBuild;

        const sizeDifference = Math.abs(
          originalBuild.imageSize - repairedBuild.imageSize
        );
        sizeDifferences.push(sizeDifference);
        sizeRatioDifferences.push(sizeDifference / originalBuild.imageSize);
        totalSizeDifference += sizeDifference;

        totalSize += originalBuild.imageSize;

        const pathDockerInfo = join(
          config.dataFolder,
          "RQ4/dockerhub_info",
          `${owner}-${repo}.json`
        );
        if (existsSync(pathDockerInfo)) {
          const hubInfo = JSON.parse(await readFile(pathDockerInfo, "utf-8"));

          if (hubInfo.pull_count) {
            const jan6th2022 = new Date("2023-01-06").getTime();
            const nbDays =
              (jan6th2022 - new Date(hubInfo.date_registered).getTime()) /
              (1000 * 3600 * 24);
            const avgPullPerDay = hubInfo.pull_count / nbDays;
            const avgPullPerWeek = avgPullPerDay * 7;

            nbDockerHub += 1;
            totalPull += hubInfo.pull_count;
            totalPullWeek += avgPullPerWeek;

            nbSmellInDockerHub += nbSmellInFile;
            nbRepairedSmellInDockerHub += nbSmellInFile - violations.length;

            const savedPerWeek =
              (sizeDifference * avgPullPerWeek) / argv.compressionRatio;

            totalDockerHubSizeDifference += sizeDifference;

            totalSavedWeek += savedPerWeek;
            smellNames.forEach((smell) => {
              if (!pullPerRule[smell]) {
                pullPerRule[smell] = [];
                downloadPerWeekPerRule[smell] = [];
                downloadSavedPerWeekPerRule[smell] = [];
              }

              downloadPerWeekPerRule[smell].push(avgPullPerWeek);
              pullPerRule[smell].push(hubInfo.pull_count);
              downloadSavedPerWeekPerRule[smell].push(savedPerWeek);
            });
          }
        }

        smellNames.forEach((smell) => {
          if (!sizeDifferencesPerSmell[smell]) {
            sizeDifferencesPerSmell[smell] = [];
            sizeRatioDifferencesPerSmell[smell] = [];
            totalSizePerSmell[smell] = [];
          }
          sizeDifferencesPerSmell[smell].push(sizeDifference);
          sizeRatioDifferencesPerSmell[smell].push(
            sizeDifference / originalBuild.imageSize
          );
          totalSizePerSmell[smell].push(originalBuild.imageSize);
        });
        // console.log(
        //   `[${name}] Difference: ${bytesToSize(
        //     sizeDifference
        //   )} bytes (${Math.round(
        //     (sizeDifference * 100) / originalBuild.imageSize
        //   )}%), ${Math.abs(
        //     originalBuild.endTimestamp -
        //       originalBuild.startTimestamp -
        //       (repairedBuild.endTimestamp - repairedBuild.startTimestamp)
        //   )} ms`
        // );
      } catch (error) {
        console.error(`Error while processing ${owner}/${repoFile}`);
        // await rm(join(resultPath, owner, repoFile));
      }
    }
  }
  console.log(`Failed repairs: ${nbFailedRepair}/${nbRepair}`);
  console.log(
    `Exec time: ${msToReadableTime(totalTime)},  Avg: ${msToReadableTime(
      totalTime / nbRepair
    )}`
  );

  console.log(
    `Diff Total: ${bytesToSize(
      sizeDifferences.reduce((a, b) => a + b, 0)
    )} (${percent(
      sizeDifferences.reduce((a, b) => a + b, 0),
      totalSize
    )}), Avg: ${bytesToSize(
      sizeDifferences.reduce((a, b) => a + b, 0) / sizeDifferences.length
    )} (${percent(
      sizeRatioDifferences.reduce((a, b) => a + b, 0) /
        sizeRatioDifferences.length
    )}), Med: ${bytesToSize(
      sizeDifferences.sort((a, b) => a - b)[
        Math.floor(sizeDifferences.length / 2)
      ]
    )} (${percent(
      sizeRatioDifferences.sort((a, b) => a - b)[
        Math.floor(sizeRatioDifferences.length / 2)
      ]
    )}), Min: ${bytesToSize(Math.min(...sizeDifferences))} (${percent(
      Math.min(...sizeRatioDifferences)
    )}), Max: ${bytesToSize(Math.max(...sizeDifferences))} (${percent(
      Math.max(...sizeRatioDifferences)
    )})`
  );

  for (const smell of SMELL_NAMES.sort((a, b) => {
    if (
      (sizeDifferencesPerSmell[a] || []).reduce((a, b) => a + b, 0) >
      (sizeDifferencesPerSmell[b] || []).reduce((a, b) => a + b, 0)
    )
      return -1;
    if (
      (sizeDifferencesPerSmell[a] || []).reduce((a, b) => a + b, 0) <
      (sizeDifferencesPerSmell[b] || []).reduce((a, b) => a + b, 0)
    )
      return 1;
    return 0;
  })) {
    const sizeDifferencesRule = sizeDifferencesPerSmell[smell] || [];
    const sortedSizeDifferencesRule = [...sizeDifferencesRule].sort(
      (a, b) => b - a
    );
    const medDiff =
      sortedSizeDifferencesRule[Math.floor(sizeDifferencesRule.length / 2)] ||
      0;
    const sumDiff = sizeDifferencesRule.reduce((a, b) => a + b, 0);
    const sizeRatioDifferences = sizeRatioDifferencesPerSmell[smell] || [];
    const sortedSizeRatioDifferences = [...sizeRatioDifferences].sort(
      (a, b) => b - a
    );
    const totalSize = totalSizePerSmell[smell] || [];
    const totalSizeSorted = [...totalSize].sort((a, b) => b - a);
    const sumTotalSize = totalSize.reduce((a, b) => a + b, 0);
    const medSize = totalSizeSorted[Math.floor(totalSize.length / 2)] || 0;
    console.log(
      `${smell} & \\np{${sizeDifferencesRule.length}} & ${latexBytesToSize(
        sumDiff,
        1
      )} (${latexPercent(sumDiff, sumTotalSize, 1)}) & ${latexBytesToSize(
        sumDiff / sizeDifferencesRule.length,
        1
      )} (${latexPercent(
        sumDiff / sizeDifferencesRule.length,
        sumTotalSize / sizeDifferencesRule.length,
        1
      )}) & ${latexBytesToSize(medDiff, 1)} (${latexPercent(
        medDiff,
        medSize,
        1
      )}) & ${latexBytesToSize(
        sortedSizeDifferencesRule[0] || 0,
        1
      )} (${latexPercent(
        sortedSizeRatioDifferences[0] || 0,
        undefined,
        1
      )}) & \\np{${
        pullPerRule[smell]?.reduce((a, b) => a + b, 0) || 0
      }} & \\np{${Math.round(
        downloadPerWeekPerRule[smell]?.reduce((a, b) => a + b, 0) || 0
      )}} & ${latexBytesToSize(
        downloadSavedPerWeekPerRule[smell]?.reduce((a, b) => a + b, 0) || 0
      )} \\\\`
    );
  }

  console.log(`\\def\\totalSize{${latexBytesToSize(totalSize)}}`);
  console.log(
    `\\def\\totalSpaceSaved{${latexBytesToSize(
      sizeDifferences.reduce((a, b) => a + b, 0)
    )}}`
  );
  console.log(
    `\\def\\avgSpaceSaved{${latexBytesToSize(
      sizeDifferences.reduce((a, b) => a + b, 0) / sizeDifferences.length
    )}}`
  );
  console.log(
    `\\def\\medSpaceSaved{${latexBytesToSize(
      sizeDifferences.sort((a, b) => a - b)[
        Math.floor(sizeDifferences.length / 2)
      ]
    )}}`
  );
  console.log(
    `\\def\\maxSpaceSaved{${latexBytesToSize(Math.max(...sizeDifferences))}}`
  );
  console.log(
    `\\def\\totalDockerHubSizeDifference{${latexBytesToSize(
      totalDockerHubSizeDifference
    )}}`
  );
  console.log(`\\def\\nbSmellInBuildable{${nbSmell}}`);
  console.log(`\\def\\nbSmellInRepaired{${nbSmellInRepaired}}`);
  console.log(
    `\\def\\nbRepairedSmellInBuildable{${nbSmell - nbSmellInRepaired}}`
  );
  console.log(`\\def\\nbSmellInDockerHub{${nbSmellInDockerHub}}`);
  console.log(
    `\\def\\nbRepairedSmellInDockerHub{${nbRepairedSmellInDockerHub}}`
  );
  console.log(`\\def\\nbDockerHub{${nbDockerHub}}`);
  console.log(`\\def\\totalPull{${totalPull}}`);
  console.log(`\\def\\totalPullWeek{${Math.round(totalPullWeek)}}`);
  console.log(`\\def\\totalSaved{${latexBytesToSize(totalSizeDifference)}}`);
  console.log(`\\def\\totalSavedWeek{${latexBytesToSize(totalSavedWeek)}}`);
})();
