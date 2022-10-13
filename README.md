# JUnit Testing Tools Competition Results Dataset

This repository contains the results of the past JUnit tool competitions since 2013.

## Structure

Each competition result is stored in a folder named after the year the edition of the competition took place. This folder contains a CSV file with the following structure:

- `benchmark`: the reference of the benchmark class under test.
- `tool`: the name of the tool.
- `runs`: the number of repeated executions for test case generation and execution.
- `tgen`: the generation time took by the tool to generate the tests.
- `texec`: the execution time of the tests.
- `avgcovi`: the average instruction coverage of the tests for `runs` executions on the `benchmark` class udner test.
- `avgcovb`: the average branch coverage of the tests for `runs` executions on the `benchmark` class udner test.
- `avgcovm`: the average mutation score of the tests for `runs` executions on the `benchmark` class udner test.

Folder `Rscripts/` contains analysis scripts generating general statistics about the results of the competitions. Plots are generated in the `plots/` folder. Use `Make`to launch the analysis (requires `R`to be installed).
