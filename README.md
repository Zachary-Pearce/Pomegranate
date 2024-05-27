the readme guidlines on the github page says this is the typical structure:
- how users can get started with the project
- where users can get help with your project
- who maintains and contributes to the project

however for our purposes we could get away without saying who maintains the project and most of the information like "where users can get help with your project" can mostly be covered by the code of conduct and with other contribution information such as a section that just says something like "if you need help regarding a change or clarification please open an issue with the following tag...".

I REALLY wish we could get a logo for the top of the readme rather than having an ugly title at the top that just looks a bit cramped in my opinion. I can definitely use blender to make one.

# Pomegranate
Choosing a processor for an embedded system is a delicate balancing act between flexibility and performance, however if a reconfigurable processor core was available and accessible then the cost of designing such systems would decrease as an existing design could be easily modified to fit an applcation and changed in the future if needs change.

Pomegranate is an open source soft-core processor written in VHDL. The goal of Pomegranate is to provide an accessible and easy to configure processor core that can be used in a varierty of FPGA projects.

## Contribution
Some notes regarding contribution below, write these up nicely:

provide a readme file explaining the module created, it's design choices, and any applicable standards. We will add a link to the relevant folder under tests when it is pushed to the repo.

provide a readme with the testbench file for the module that shows simulation results, this includes:
- simulation waveforms.
- utilisation graphs for at least one compatible platform.
- please provide a table of tested and compatible platforms, we ask that at least all xilinx chips are used for testing, not all of these have to be made compatible if you find it difficult. However, you may make your module compatible with more platforms if you wish however these platforms must be stated.

## Compatible Platforms
Pomegranate as a whole cannot be rated on compatibility as it depends on the specific implementation. However, each components portability is noted through successful synthesis and implementation, comments are also given describing errors and their severity.

| Family | Vendor | Synthesized? (P/F) | Implemented? (P/F) | Comments |
| --- | --- | :---: | :---: | --- |
| Zynq 7000 | AMD Xilinx | P | P | Failed timing report (critical warning) |
| Spartan 7 | AMD Xilinx | P | P | No errors |
| Artix 7 | AMD Xilinx | P | P | No errors |
| Kintex 7 | AMD Xilinx | Untested | Untested | NA |
| Virtex 7 | AMD Xilinx | P | F | Conflicting voltages in bank 17 (error) |

Note that even though all the components used may be compatible with a particular family, minor changes may still need to be made when they are stitched together in your final deployment.

## Change Log
See the [Releases](https://github.com/Zachary-Pearce/Pomegranate/releases/) page. I also post about interesting discoveries and major changes on my [LinkedIn](https://www.linkedin.com/in/zachary-pearce-231307243/).
