Thank you for your interest in contributing to Pomegranate, this document describes how you should contribute; documentation, modules, and optimisations so that you can maximise the chance of your pull request being accepted.

# Getting Started
A deployment of Pomegranate will be made up of multiple computational elements (or modules), this repository serves as a collection of these modules and provides a framework to connect them. If you are contributing a module then it is important to first read the wiki.

If you are contributing optimisations to an existing element then it is important to also read the README supplied with it in order to familiarise yourself with it's function and design decisions.

If there are multiple contributions you wish to make, we ask that these are sent in separate pull requests, a pull request that contributes optimisations to multiple modules will be denied.

## Development Environment
This repository works on pull requests, so please create a fork of the repository and clone your fork, you can then work from this and submit a pull request when you're ready to do so.

We would prefer that you use Vivado to simulate your designs as this will keep utilisation graphs and errors in a similar format. You can download the latest version of the Vivado design suite [here](https://www.xilinx.com/products/design-tools/vivado.html).

# Contributing Modules
When contributing modules it is important that others can understand what the module is doing and why it is doing it. For this reason, A module of your own design must be accompanied by a README that includes the following:
- An explanation of the modules function and it's application(s).
- An explanation of any design choices.
- Any standards that were followed during the design process.
- A link to the testing files at the end of the document.

Following on from the last point, it is important that any testbench files used are contributed in the same pull request in a folder under "testing" with the same name as the folder that holds the design files. (Add an exaplanation image here)

Testbench files must also be accompanied with a README that shows simulation results, this should include:
- Simulation waveforms.
- Utilisation graphs for at least one compatible platform.
- Timing reports.
- A table of tested and compatible platforms.

## Tested and Compatible Platforms
Tested and compatible platforms should be provided in a table with the following format.

| Family | Vendor | Synthesized? | Implemented? | Comments |
| --- | --- | :---: | :---: | --- |
| Zynq 7000 | AMD Xilinx | :white_check_mark: | :white_check_mark: | Failed timing report (critical warning) |
| Spartan 7 | AMD Xilinx | :white_check_mark: | :white_check_mark: | No errors |
| Artix 7 | AMD Xilinx | :white_check_mark: | :white_check_mark: | No errors |
| Kintex 7 | AMD Xilinx | :grey_question: | :grey_question: | NA |
| Virtex 7 | AMD Xilinx | :white_check_mark: | :x: | Conflicting voltages in bank 17 (error) |

The compatibility of a module with a platform is noted through successful synthesis and implementation which is indicated as passed :white_check_mark:, failed :x:, or untested :grey_question:. Comments are given that describe any errors or critical warnings returned after synthesis and implementation.

We ask that that the 5 Xilinx chips given in the above table are tested. However, not all of these have to be compatible if you experience difficulties. You may test with/make compatible more platforms but these must be stated.

You may also note intended future platform compatibility by marking it as untested (:grey_question:) as seen with the "Kintex 7" platform in the example table.

# Contributing Optimisations
Optimisations refer to small changes to an existing module in the repository, this could be optimisations that simplify code, reduce delay, reduce resource utilisation, or improve compatibility. Optimisations should not change the core of the design and as such remain consistent with the supplied README.

Before making optimisations it's important that you can justify the change, make sure you are solving a problem rather than finding a problem to solve. Once you have made your optimisations, you must present notable improvements in your pull request which backs up your justification. Please also update the test README with any new results (e.g. Utilisation graphs).

As such, an optimisation pull request must include the following:
- Problem justification.
- Results that show a clear improvement.
- Updated test documentation, if applicable.

# Contributing Documentation
Documentation can refer to a README supplied with a module or its testbench, or wiki pages. We expect most developers to contribute their own documentation with their pull requests. However, we are aware that writing is not every developers forte. It certainly isn't mine.

Therefore we accept improvements to the grammar, spelling, and clarity of any documentation. These improvements must not change the ideas communicated.

# Where to Get Help
Not really sure on what to write here, but here are the notes I made on it...

"where users can get help with your project" can mostly be covered by the code of conduct and with other contribution information such as a section that just says something like "if you need help regarding a change or clarification please open an issue with the following tag...".