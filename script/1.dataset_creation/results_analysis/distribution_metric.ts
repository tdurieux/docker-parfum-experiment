import { readFile } from "fs/promises";
import Yargs from "yargs/yargs";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("file", {
      type: "string",
      demandOption: true,
      alias: "f",
    })
    .parse();

  const distribution: { [key: string]: number } = JSON.parse(
    await readFile(argv.file, "utf-8")
  );

  const nb = Object.values(distribution).reduce((a, b) => a + b, 0);
  const sum = Object.keys(distribution)
    .map((key) => distribution[key] * parseInt(key))
    .reduce((a, b) => a + b, 0);
  const avg = sum / nb;
  const med = Object.keys(distribution)
    .map((key) => new Array<number>(distribution[key]).fill(parseInt(key)))
    .flat()
    .sort((a, b) => a - b)[Math.floor(nb / 2)];
  console.log(`Total: ${sum}, Average: ${avg}, Median: ${med}`);
})();
