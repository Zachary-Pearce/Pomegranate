![Pomegranate](https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/TempLogo.png)

Choosing a processor for an embedded system is a delicate balancing act between flexibility and performance, however if a reconfigurable processor core was available and accessible then the cost of designing such systems would decrease as an existing design could be easily modified to fit an applcation and changed in the future if needs change.

Pomegranate is an open source soft-core processor written in VHDL. The goal of Pomegranate is to provide an accessible and easy to configure processor core that can be used in a varierty of embedded systems.

# Getting Started
You can start by familiarising yourself with the wiki which covers:
- Link 1 (Pomegranate's mission, and how it seeks to achieve it)
- Link 2 (architecture details; instruction set, base architecture)
- Link 3 (configuring Pomegranate)
- Link 4 (programming Pomegranate)

# Contribution
Please read the [contribution guidelines](https://github.com/Zachary-Pearce/Pomegranate/blob/main/.github/CONTRIBUTING.md) before starting, this will cover what needs to be provided in a contribution, if a pull request is missing any of the requirements it will be automatically declined.

# Compatible Platforms
Pomegranate as a whole cannot be rated on compatibility as it depends on the specific implementation. However, each components portability is noted through successful synthesis and implementation, comments are also given describing errors and their severity.

| Family | Vendor | Synthesized? (P/F) | Implemented? (P/F) | Comments |
| --- | --- | :---: | :---: | --- |
| Zynq 7000 | AMD Xilinx | P | P | Failed timing report (critical warning) |
| Spartan 7 | AMD Xilinx | P | P | No errors |
| Artix 7 | AMD Xilinx | P | P | No errors |
| Kintex 7 | AMD Xilinx | Untested | Untested | NA |
| Virtex 7 | AMD Xilinx | P | F | Conflicting voltages in bank 17 (error) |

Note that even though all the components used may be compatible with a particular family, minor changes may still need to be made when they are stitched together in your final deployment.

# Change Log
See the [Releases](https://github.com/Zachary-Pearce/Pomegranate/releases/) page. I also post about interesting discoveries and major changes on my [LinkedIn](https://www.linkedin.com/in/zachary-pearce-231307243/).
