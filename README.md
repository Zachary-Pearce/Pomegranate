# Pomegranate
Pomegranate is an open source soft-core processor written in VHDL. The goal of pomegranate is to provide an accessible and highly configurable processor architecture that can be used in a variety of FPGA projects.

Choosing a processor for an embedded system is a delicate balancing act between flexibility and performance. Pomegranate exists to provide an architecture with performance that can be easily reconfigured in the future.

To make Pomegranate configurable, the system is designed to be scalable so computational elements can be removed, added, or modified wihout harming the synthesisability of the architecture. In order for Pomegranate to be accessible it is designed to be source-level portable, this meaning that any form of Pomegranate should be synthesisable on different FPGA platforms with little to no required changes.

Portability is currently focussed on Xilinx family chips.

## Development
I don't really know how this whole contribution thing is going to work yet to be honest with you.

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
