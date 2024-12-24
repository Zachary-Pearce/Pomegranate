<p align="center">
    <picture>
        <source media="(prefers-color-scheme: light)" srcset="https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/logo/pomeg-dark.png" width="250px"/>
        <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/logo/pomeg-white.png" width="250px"/>
        <img src="https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/logo/pomeg-white.png"  style="display: block; width:100%; height:auto;">
    </picture>
    <br>
    <img src="https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg" alt="Contributor Covenant Badge">
    <img src="https://img.shields.io/badge/Vivado-2024.1-green" alt="Vivado 2024.1">
</p>

Pomegranate is an open source scalable and portable soft-core processor written in VHDL, it's goal is to teach you the fundamentals behind computer architecture by meeting you where you're at and scaling with you as you tackle progessively complex concepts. This allows you to build a solid foundation of knowledge and build on it brick by brick with a real practical example.

# Welcome
First of all, welcome to Pomegranate, We reccomend that you start by familiarising yourself with the [wiki](https://github.com/Zachary-Pearce/Pomegranate/wiki), the wiki pages will teach you about the Pomegranate base architecture and how to configure it as well as holding various lessons on computer architecture for you to follow.

If you're not sure where to start, you can read about that [here](https://github.com/Zachary-Pearce/Pomegranate/wiki#Where-should-I-start?)

## Repository Structure
The modules are stored in the [src](https://github.com/Zachary-Pearce/Pomegranate/tree/main/src) folder. Each module has it's own sub folder with the code and a README describing it's design.

Testbench files are stored in the [testing](https://github.com/Zachary-Pearce/Pomegranate/tree/main/testing) folder. Each module that has had a testbench simulation conducted has a sub folder which contains the testbench and a README that describes the tests conducted as well as resource utilisation, timing reports and resulting maximum clock frequency, and compatible FPGA platforms.

## Can I use this design in my projects?
If you think that this design would be a good fit for your project then please use it. As it is made to be easily edited, you should be able to adapt it for whatever purpose you want.

Compatibility with every FPGA is not guaranteed, but Pomegranate is designed to be compatible with as many Xilinx FPGAs as possible.

### How to use
There are two main parts to this design.
* The package.
* The modules.

The modules are instanced in a structurally modelled top level file and connected together. You can write your own top file for this purpose however there is one provided [here](https://github.com/Zachary-Pearce/Pomegranate/tree/main/src/Top) for the base architecture.

The package is the main source of all configuration in a deployment of Pomegranate. It defines the instruction set and formats as well as several helper functions to allow the system to be more easily scaled. A package pre-configured for the base architecture can be found [here](https://github.com/Zachary-Pearce/Pomegranate/tree/main/Package) however if you want to configure your own, the [Configuring Pomegranate](https://github.com/Zachary-Pearce/Pomegranate/wiki/Configuring-Pomegranate) wiki page will show you how.

# Contribution
Please read the [contribution guidelines](https://github.com/Zachary-Pearce/Pomegranate/blob/main/.github/CONTRIBUTING.md) before starting. You can also contribute to the project by answering issues.

# Change Log
See the [Releases](https://github.com/Zachary-Pearce/Pomegranate/releases/) page. I also post about interesting discoveries and major changes
on my [LinkedIn](https://www.linkedin.com/in/zachary-pearce-231307243/).
