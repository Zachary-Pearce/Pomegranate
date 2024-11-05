Thank you for your interest in contributing to Pomegranate! This document describes how you should contribute; documentation, modules, and optimisations so that you can maximise the chance of your pull request being accepted.

# Getting Started
This repositories main purpose is to teach others about computer architecture, the highest level of understanding we can provide is limited by the computational elements (or modules) we have access to. This repository also serves as a collection of those modules we can use in configurations of Pomegranate to teach particular concepts. For example, you could contribute a floating point ALU which would allow us to teach floating point representation and arithmetic. If you want to contribute a module then I reccomend you read the following from the wiki:
* Link 1 (Pomegranate's mission, and how it seeks to achieve it)
* Link 2 (architecture details; instruction set, base architecture)
* Link 3 (configuring Pomegranate)

If you are contributing optimisations to an existing module then it is important to also read the README supplied with it to familiarise yourself with its function and design decisions.

If there are multiple contributions you wish to make, we ask that these be sent in separate pull requests, a pull request that contributes optimisations to multiple modules will be denied.

## Development Environment
We would prefer that you use Vivado to simulate your designs as this will keep errors in a similar format. You can download the latest free version of the Vivado design suite [here](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado/vivado-buy.html).

# Contributing Modules
The most important aspect of any contributed code is it being well commented and readable, you can make a good design but others must be able to understand what your module is doing and why. To support this, A module of your design must be accompanied by a README that includes the following:
* An explanation of the module's design and justification for choices made.
* A list of standards if any that were followed during the design process.
* A link to the testing files on this repository at the end of the document.

Following on from the last point, any testbenches used must be contributed in the same pull request in a folder under "testing" with the same name as the folder that holds the design files. (Add an explanation image here)

Testbench files must also be accompanied by a README that shows simulation results, this should include:
* Simulation waveforms.
* A table showing the number of resources used.
* Timing reports.
* A table of tested and compatible platforms.

Templates for these READMEs can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/.github/README_TEMPLATES).

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

We ask that the 5 Xilinx chips given in the above table be tested. However, not all of these have to be compatible if you experience difficulties. You may test with/make compatible more platforms but these must be stated.

You may also note intended future platform compatibility by marking it as untested :grey_question: as seen with the "Kintex 7" platform in the example table.

# Contributing Optimisations
Optimisations refer to small changes to an existing module in the repository, this could be optimisations that simplify code, reduce delay, reduce resource utilisation, or improve compatibility. Optimisations should not change the core of the design and as such remain consistent with the supplied README.

Before making optimisations you must be able to justify the change. Make sure you are solving a problem rather than finding a problem to solve. Once you have made your optimisations, you must present notable improvements in your pull request which backs up your justification. Please also update the test README with any new results (e.g. Resource utilisation).

As such, an optimisation pull request must include the following:
* Problem justification.
* Results that show a clear improvement.
* Updated test documentation, if applicable.

# Contributing Documentation
Documentation can refer to a README supplied with a module or its testbench, or wiki pages. We expect contributors to provide documentation with their pull requests. However, we are aware that writing is not every developer's forte. Therefore we accept improvements to the grammar, spelling, and clarity of any documentation. These improvements must not change the ideas communicated.