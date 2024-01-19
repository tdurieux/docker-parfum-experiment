import { readFile } from "fs/promises";
import { join } from "path";
import Yargs from "yargs/yargs";
import config from "../../../config";
import { RepositoryAnalysisResult } from "../../3.RQ2/repair_repository_dockerfile";
import {
  createOctokit,
  bytesToSize,
  latexBytesToSize,
  latexPercent,
  SIZE_RULES,
  smellName,
} from "../../utils";
import { RestEndpointMethodTypes } from "@octokit/rest";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("anonymous", {
      type: "boolean",
      demandOption: false,
      alias: "a",
    })
    .option("results", {
      type: "string",
      demandOption: false,
      alias: "p",
      default: join(config.dataFolder, "RQ4/opened_prs.csv"),
    })
    .option("token", {
      alias: "t",
      describe: "The GitHub token",
      type: "string",
      demandOption: false,
      default: process.env.GITHUB_TOKEN,
    })
    .option("compression-ratio", {
      type: "number",
      demandOption: false,
      alias: "c",
      default: 3.2,
    })
    .parse();

  const prInfos: {
    gh: RestEndpointMethodTypes["pulls"]["get"]["response"]["data"];
    anoUrl: string;
  }[] = [];
  const lines = (await readFile(argv.results, "utf-8")).split(`\n`);
  for (const line of lines) {
    const [_, prUrl, anoUrl] = line.split(",");
    const [owner, repo, prNumber] = prUrl
      .replace("/pull", "")
      .replace("https://github.com/", "")
      .split("/");
    const octokit = createOctokit(argv.token);
    const r = await octokit.pulls.get({
      owner,
      repo,
      pull_number: parseInt(prNumber),
    });

    prInfos.push({ gh: r.data, anoUrl });
  }

  let totalSpace = 0;
  let totalSpaceMerged = 0;
  let totalSpaceSavedPerWeek = 0;
  let nbAcceptedPR = 0;
  let nbRefusedPR = 0;
  let nbMergedRepairedSmell = 0;
  let downloadTimePerWeek: number[] = [];

  const mergedSmellRepair: { [key: string]: number } = {};

  let mdOutput = "| URL | # Repaired Smells | PR Status |\n|----|---|---|";

  let prNumber = 1;
  for (const prInfo of prInfos.sort((a, b) => {
    if (a.gh.merged && !b.gh.merged) {
      return -1;
    }
    if (!a.gh.merged && b.gh.merged) {
      return 1;
    }
    if (a.gh.merged && b.gh.merged) {
      return a.gh.merged_at > b.gh.merged_at ? 1 : -1;
    }
    return a.gh.created_at > b.gh.created_at ? 1 : -1;
  })) {
    const buildInfo: RepositoryAnalysisResult = JSON.parse(
      await readFile(
        join(
          config.defaultBuildDockerfileOutputPath,
          prInfo.gh.base.repo.full_name + ".json"
        ),
        "utf-8"
      )
    );

    const hubInfo = JSON.parse(
      await readFile(
        join(
          config.dataFolder,
          "RQ4/dockerhub_info",
          prInfo.gh.base.repo.full_name.replace("/", "-") + ".json"
        ),
        "utf-8"
      )
    );

    // date when dockerhub information was collected
    const jan6th2022 = new Date("2023-01-06").getTime();
    const nbDays =
      (jan6th2022 - new Date(hubInfo.date_registered).getTime()) /
      (1000 * 3600 * 24);
    const avgPullPerDay = hubInfo.pull_count / nbDays;
    const diff =
      buildInfo.originalBuild.imageSize - buildInfo.repairedBuild.imageSize;

    mdOutput += `\n| ${prInfo.gh.html_url} | ${
      buildInfo.repair.violations.length
    } | ${
      prInfo.gh.merged
        ? "Merged"
        : prInfo.gh.state == "open"
        ? "Open"
        : "Closed"
    } |`;
    if (prInfo.gh.merged) {
      nbAcceptedPR += 1;
      totalSpace += buildInfo.originalBuild.imageSize;
      totalSpaceMerged += diff;
      totalSpaceSavedPerWeek +=
        (diff * avgPullPerDay * 7) / argv.compressionRatio;
      downloadTimePerWeek.push(avgPullPerDay * 7);
      nbMergedRepairedSmell += buildInfo.repair.violations.length;

      for (const smell of buildInfo.repair.violations) {
        if (!mergedSmellRepair[smellName(smell.name)]) {
          mergedSmellRepair[smellName(smell.name)] = 0;
        }
        mergedSmellRepair[smellName(smell.name)] += 1;
      }
    } else if (prInfo.gh.state === "closed") {
      nbRefusedPR += 1;
    } else {
      continue;
    }

    let repoName = prInfo.gh.base.repo.full_name.replace("_", "\\_");
    let url = prInfo.gh.html_url;
    let PRID = prInfo.gh.number.toString();
    if (argv.anonymous) {
      repoName = "XXXX";
      url = prInfo.anoUrl;
      PRID = "X";
    }
    if (prInfo.gh.merged) {
    }
    console.log(
      `${prNumber++} & \\href{${url}}{${repoName}} & ${
        prInfo.gh.base.repo.stargazers_count
      } & \\np{${hubInfo.pull_count}} & \\np{${Math.round(
        avgPullPerDay * 7
      )}} & ${latexBytesToSize(
        buildInfo.originalBuild.imageSize
      )} & ${PRID} & ${
        prInfo.gh.merged
          ? "Merged"
          : prInfo.gh.state == "open"
          ? "Open"
          : "Closed"
      } & ${buildInfo.repair.violations.length} & ${bytesToSize(
        diff
      )} (${latexPercent(
        diff,
        buildInfo.originalBuild.imageSize
      )}) & ${latexBytesToSize(
        (diff * avgPullPerDay * 7) / argv.compressionRatio
      )} \\\\`
    );
  }

  console.log(mdOutput);

  for (const smell of SIZE_RULES) {
    if (!mergedSmellRepair[smell.name]) {
      continue;
    }
    console.log(`${smell.name} & \\np{${mergedSmellRepair[smell.name]}} \\\\`);
  }

  console.log(`\\def\\nbPRs{${prInfos.length}}`);
  console.log(`\\def\\nbAcceptedPR{${nbAcceptedPR}}`);
  console.log(`\\def\\nbRefusedPR{${nbRefusedPR}}`);
  console.log(`\\def\\nbMergedRepairedSmell{${nbMergedRepairedSmell}}`);
  console.log(`\\def\\totalSpacePR{${latexBytesToSize(totalSpace)}}`);
  console.log(`\\def\\totalSpaceMerged{${latexBytesToSize(totalSpaceMerged)}}`);
  console.log(
    `\\def\\totalSpaceSavedPerWeek{${latexBytesToSize(totalSpaceSavedPerWeek)}}`
  );
  const mergedDownloadTimeWeek = downloadTimePerWeek.reduce((a, b) => a + b, 0);
  console.log(
    `\\def\\mergedDownloadTimeWeek{${Math.round(mergedDownloadTimeWeek)}}`
  );
})();
