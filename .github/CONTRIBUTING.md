Thank you for your interesting in contributing to Pomegranate, this document describes how you should contribute; documentation, modules, and optimisations so that you can maximise the chance of your pull request being accepted.

# Getting Started
A deployment of Pomegranate will be made up of multiple computational elements (or modules), this repository serves as a collection of these modules and provides a framework to connect them. If you are contributing a module then it is important to first read the wiki.

If you are contributing optimisations to an existing element then it is important to also read the README supplied with it in order to familiarise yourself with it's function and design decisions.

If there are multiple contributions you wish to make, we would prefer that these are sent in separate pull requests, for example a pull request that contributes optimisations to multiple modules will be denied.

## Development Environment
Preferably Vivado so that the utilisation graphs and statistics are laid out in a similar format, but there is no reason why people couldn't use another IDE in reality.

The only other step would be to create a new branch and clone to get the code locally and ready for changes.

# Contributing Modules
When contributing modules it is important that others can understand what the module is doing and why it is doing it. For this reason, A module of your own design must be accompanied by a README that includes the following:
- An explanation of the modules function and it's application(s).
- An explanation of any design choices.
- Any standards that were followed during the design process.
- A link to the testing files at the end of the document

Following on from the last point, it is important that any testbench files used are contributed in the same pull request in a folder under "testing" with the same name as the folder that holds the design files. (Add an exaplanation image here)

Testbench files must also be accompanied with a README that shows simulation results, this should include:
- Simulation waveforms.
- Utilisation graphs for at least one compatible platform.
- A table of tested and comptatible platforms.

## Tested and Compatible Platforms
Tested and compatible platforms should be provided in a table with the following format.

| Family | Vendor | Synthesized? (P/F) | Implemented? (P/F) | Comments |
| --- | --- | :---: | :---: | --- |
| Zynq 7000 | AMD Xilinx | P | P | Failed timing report (critical warning) |
| Spartan 7 | AMD Xilinx | P | P | No errors |
| Artix 7 | AMD Xilinx | P | P | No errors |
| Kintex 7 | AMD Xilinx | Untested | Untested | NA |
| Virtex 7 | AMD Xilinx | P | F | Conflicting voltages in bank 17 (error) |

The compatibility of a module with a platform is noted through successful synthesis and implementation, comments are also given that describes any errors or critical warnings in the event that synthesis or implemenation fails.

We ask that that the 5 Xilinx chips given in the above table are tested. However, not all of these have to be compatible if you experience difficulties. You may test with/make compatible more however platforms must be stated in the table.

# Contributing Optimisations
Unlike with contributing new modules, making optimisations require no extra files and there should be no changes to the documentation, we only ask that you follow the relevant pull request template and update any relevant test documentation, commonly the utilisation graphs.

# Where to Get Help
Not really sure on what to write here, but here are the notes I made on it...

"where users can get help with your project" can mostly be covered by the code of conduct and with other contribution information such as a section that just says something like "if you need help regarding a change or clarification please open an issue with the following tag...".