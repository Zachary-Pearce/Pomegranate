<p align="center">
    <picture>
        <source media="(prefers-color-scheme: light)" srcset="https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/logo/pomeg-dark.png" width="200px"/>
        <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/logo/pomeg-white.png" width="200px"/>
        <img src="https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/logo/pomeg-white.png"  style="display: block; width:100%; height:auto;">
    </picture>
    <br>
    <img src="https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg" alt="Contributor Covenant Badge">
    <img src="https://img.shields.io/badge/Vivado-2024.1-green" alt="Vivado 2024.1">
</p>

Pomegranate is an open source scalable and portable soft-core processor written in VHDL, it's goal is to teach you the fundamentals behind computer architecture
by meeting you where you're at and scaling with you as you tackle progessively complex concepts. This allows you to build a solid foundation of knowledge and
build on it brick by brick with a real practical example.

# Welcome
First of all, welcome to Pomegranate. This project started as my undergraduate thesis, I wanted it to become more than I could make it on my own so I started
this repository. To get started, I reccomend that you start familiarising yourself with the wiki which covers:
- Link 1 (Pomegranate's mission, and how it seeks to achieve it)
- Link 2 (architecture details; instruction set, base architecture)
- Link 3 (configuring Pomegranate)
- Link 4 (programming Pomegranate)

## What if I don't know VHDL?
No matter how you stumbled across this repository, if you are using it to learn computer architecture it may seem daunting if you have not learnt VHDL, however
I wasn't exactly an expert in it until I had really started to learn it during and after my undergraduate thesis. There are resources you can use, if you are a
university student you will likely have access to textbooks, [such as this one](https://www.amazon.co.uk/Digital-System-Design-VHDL-Zwolinski/dp/013039985X) which
I used to learn VHDL at first and also has a simple processor example you can follow.

Every piece of VHDL has been well commented explaining why the code is written how it is with the intent of helping you where it can. In terms of software, Vivado
was used to program and test all of Pomegranate and there is a free version available [here](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado/vivado-buy.html).
Lastly, if you experience any difficulties, open an issue.

## Can I use this design in my projects?
If you think that this design would be a good fit for your project then please use it. As it is made to be easily edited, you should be able to adapt it
for whatever purpose you want.

Compatibility with every FPGA development board is not gauranteed, but Pomegranate is designed to be compatible with as many Xilinx FPGAs as possible.

# Contribution
Please read the [contribution guidelines](https://github.com/Zachary-Pearce/Pomegranate/blob/main/.github/CONTRIBUTING.md) before starting, as long as these
guidlines are followed there is a near 100% chance that your pull request will be accepted. You can also contribute by answering issues.

# Change Log
See the [Releases](https://github.com/Zachary-Pearce/Pomegranate/releases/) page. I also post about interesting discoveries and major changes
on my [LinkedIn](https://www.linkedin.com/in/zachary-pearce-231307243/).
