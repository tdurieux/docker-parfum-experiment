import { readFile } from "fs/promises";
import { join } from "path";
import Yargs from "yargs/yargs";
import { createOctokit } from "../../utils";
import config from "../../../config";
import { RepositoryAnalysisResult } from "../../3.RQ2/repair_repository_dockerfile";
import { bytesToSize, latexBytesToSize, latexPercent } from "../../utils";
import { RestEndpointMethodTypes } from "@octokit/rest";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("results", {
      type: "string",
      demandOption: false,
      alias: "p",
      default: join(config.dataFolder, "evaluation/opened_prs.csv"),
    })
    .option("token", {
      alias: "t",
      describe: "The GitHub token",
      type: "string",
      demandOption: false,
      default: process.env.GITHUB_TOKEN,
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

  let totalSpaceMerged = 0;
  let totalSpaceSavedPerWeek = 0;
  let nbAcceptedPR = 0;
  let nbRefusedPR = 0;
  let nbMergedRepairedSmell = 0;
  let downloadTimePerWeek: number[] = [];

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
          "evaluation/dockerhub_info",
          prInfo.gh.base.repo.full_name.replace("/", "-") + ".json"
        ),
        "utf-8"
      )
    );

    const nbDays =
      (new Date().getTime() - new Date(hubInfo.date_registered).getTime()) /
      (1000 * 3600 * 24);
    const avgPullPerDay = hubInfo.pull_count / nbDays;
    const diff =
      buildInfo.originalBuild.imageSize - buildInfo.repairedBuild.imageSize;

    if (prInfo.gh.merged) {
      nbAcceptedPR += 1;
      totalSpaceMerged += diff;
      totalSpaceSavedPerWeek += diff * avgPullPerDay * 7;
      downloadTimePerWeek.push(avgPullPerDay * 7);
      nbMergedRepairedSmell += buildInfo.repair.violations.length;
    } else if (prInfo.gh.state === "closed") {
      nbRefusedPR += 1;
    } else {
      continue;
    }

    console.log(
      `\\href{${prInfo.anoUrl}}{XXXX} & ${
        prInfo.gh.base.repo.stargazers_count
      } & \\np{${hubInfo.pull_count}} & \\np{${Math.round(
        avgPullPerDay * 7
      )}} & ${latexBytesToSize(buildInfo.originalBuild.imageSize)} & X & ${
        prInfo.gh.merged ? "Merged" : "Closed"
      } & ${buildInfo.repair.violations.length} & ${bytesToSize(
        diff
      )} (${latexPercent(
        diff,
        buildInfo.originalBuild.imageSize
      )}) & ${latexBytesToSize(diff * avgPullPerDay * 7)} \\\\`
    );
    // console.log(
    //   `${prInfo.gh.base.repo.full_name.replace("_", "\\_")} & ${
    //     prInfo.gh.base.repo.stargazers_count
    //   } & \\np{${hubInfo.pull_count}} & \\np{${Math.round(
    //     avgPullPerDay * 7
    //   )}} & ${latexBytesToSize(buildInfo.originalBuild.imageSize)} & ${
    //     prInfo.gh.number
    //   } & ${prInfo.gh.merged ? "Merged" : "Closed"} & ${
    //     buildInfo.repair.violations.length
    //   } & ${bytesToSize(diff)} (${latexPercent(
    //     diff,
    //     buildInfo.originalBuild.imageSize
    //   )}) & ${latexBytesToSize(diff * avgPullPerDay * 7)} \\\\`
    // );
  }

  console.log(`\\def\\nbPRs{${prInfos.length}}`);
  console.log(`\\def\\nbAcceptedPR{${nbAcceptedPR}}`);
  console.log(`\\def\\nbRefusedPR{${nbRefusedPR}}`);
  console.log(`\\def\\nbMergedRepairedSmell{${nbMergedRepairedSmell}}`);
  console.log(`\\def\\totalSpaceMerged{${latexBytesToSize(totalSpaceMerged)}}`);
  console.log(
    `\\def\\totalSpaceSavedPerWeek{${latexBytesToSize(totalSpaceSavedPerWeek)}}`
  );
  const mergedDownloadTimeWeek = downloadTimePerWeek.reduce((a, b) => a + b, 0);
  console.log(
    `\\def\\mergedDownloadTimeWeek{${Math.round(mergedDownloadTimeWeek)}}`
  );
})();
