# Pomegranate
Pomegranate is an open source soft-core processor developed using VHDL. The goal of pomegranate is to provide an accessible and highly configurable processor design that can be used in a variety of projects, with a focus on FGPA projects.

Pomegranate is made up of several computational elements. These can be removed, added, or modified as the designer wishes to best fit the application. While Pomegranate is presented with a "base architecture" (see below) this isn't what defines Pomegranate, what defines it is the way that the modules are designed to best support scalability.

Pomegranate is also made to be source-level portable, any form of Pomegranate should be synthesisable on different FPGA platforms with little to no required changes. For the moment, portability is focused on Xilinx family chips.

## Development
I don't really know how this whole contribution thing is going to work yet to be honest with you.

## Compatible Platforms
Pomegranate as a whole cannot be rated on compatibility as it depends on individual deployments. However, each components portability is noted through successful synthesis and implementation, comments are also given describing errors and their severity.

| Family | Vendor | Synthesized? (P/F) | Implemented? (P/F) | Comments |
| --- | --- | :---: | :---: | --- |
| Zynq 7000 | AMD Xilinx | P | P | Failed timing report (critical warning) |
| Spartan 7 | AMD Xilinx | P | P | No errors |
| Artix 7 | AMD Xilinx | P | P | No errors |
| Kintex 7 | AMD Xilinx | Untested | Untested | NA |
| Virtex 7 | AMD Xilinx | P | F | Conflicting voltages in bank 17 (error) |

Note that even though all the components used may be compatible with a particular family, minor changes may still need to be made when they are stitched together in your final deployment.

## Change Log
See the [Releases](https://github.com/Zachary-Pearce/Pomegranate/releases/) page. I will also post discoveries and major changes on my [LinkedIn](https://www.linkedin.com/in/zachary-pearce-231307243/).
