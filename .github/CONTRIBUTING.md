Thank you for your interest in contributing to Pomegranate! This document outlines how you should contribute; documentation, modules, and optimisations to maximise the chance of your pull request being accepted.

# Table of Contents
* [Contributing Modules and Optimisations](#contributing-modules-and-optimisations)
    * [Design Documentation](#design-documentation)
    * [Contributing Optimisations](#contributing-optimisations)
    * [Testing Documentation](#testing-documentation)
    * [Coding Conventions](#coding-conventions)
* [Contributing to Documentation](#contributing-documentation)
* [Making a Pull Request](#making-a-pull-request)

# Contributing Modules and Optimisations

## Design Documentation
Pomegranate accepts contributions of new modules as well as patches to existing modules. Providing and maintaining documentation is very important; it informs users how to set up your module and explains to contributors why your design is implemented the way it is. As such, we expect each module to be accompanied by a README which contains the following:
* An explanation of the module's design.
* Justification of the implementation methods where necessary.
* How to configure the module.
* Any known limitations of the design.
* A link to the [testing documentation](#testing-documentation).

> A template for writing design READMEs can be found [here](/.github/README_TEMPLATES/DESIGN.md).

### Contributing Optimisations
Optimisations refer to small changes to an existing module in the repository. These may include optimisations that simplify code, reduce delay, lower resource utilisation, or improve compatibility. Optimisations should not change the core of the design and as such remain consistent with the supplied README.

Before making optimisations you must be able to justify the change. Make sure you are solving a problem rather than finding a problem to solve. Once you have made your optimisations, you must present notable improvements in an updated testing README.

In summary, pull requests for optimisations should contain the following:
* Problem justification.
* Results that show a clear improvement.
* Updated test documentation.

## Testing Documentation
Modules must also be accompanied by a testbench and a testing README that shows the results of functional verification. These testing files must be included in the same pull request, in a folder under [testing](/testing/) with the same name as the module's [src](/src/) folder.

![Testing file location](/images/testing_files_example.png)

The testing README should contain the following:
* Simulation waveforms.
* Test cases.
* Resource utilisation.
* Timing reports.
* A table of tested and compatible platforms.

> A template for writing testing READMEs can be found [here](/.github/README_TEMPLATES/TESTING.md).

### Tested and Compatible Platforms
Tested and compatible platforms should be listed in a table using the following format.

| Family | Vendor | Synthesized? | Implemented? | Comments |
| --- | --- | :---: | :---: | --- |
| Zynq 7000 | AMD Xilinx | :white_check_mark: | :white_check_mark: | Failed timing report (critical warning) |
| Spartan 7 | AMD Xilinx | :white_check_mark: | :white_check_mark: | No errors |
| Artix 7 | AMD Xilinx | :white_check_mark: | :white_check_mark: | No errors |
| Kintex 7 | AMD Xilinx | :grey_question: | :grey_question: | NA |
| Virtex 7 | AMD Xilinx | :white_check_mark: | :x: | Conflicting voltages in bank 17 (error) |

The compatibility of a module with a platform is noted through successful synthesis and implementation which is indicated as passed :white_check_mark:, failed :x:, or untested :grey_question:. Comments are given that describe any errors or critical warnings returned after synthesis and implementation.

We ask that the 5 Xilinx chips given in the above table be tested. However, not all of these have to be compatible if you experience difficulties. You may consider additional platforms, but these must be stated.

## Coding Conventions
The most important aspect of any contributed code is that it is well-commented and readable, to aid this, we ask that all code follow a few simple rules.
1. When checking the state of a clock, always use `rising_edge(clk)` or `falling_edge(clk)`, not `clock'event`.
2. Code should naturally progress from the input to the output, with processes used only for sequential logic.
3. The combinational, sequential, and output parts should be clearly labelled.

```VHDL
--COMBINATIONAL PART HERE
-- for logic between the inputs and sequential logic
input <= input_data when SEL = '1' else other_input;

--SEQUENTIAL PART
s0: process(clk, ARST) is
begin
    if ARST = '1' then
        --some reset logic...
    elsif rising_edge(clk) then
        --some code...
    end if;
end process s0;

--AND/OR COMBINATIONAL PART HERE
-- for logic between the sequential logic and output logic
some_data <= '1' when CS = '1' else '0';

--OUTPUT PART
do <= some_data when EN = '1' else 'Z';
```

4. Testbench stimuli are presented sequentially in a process, we prefer that `wait until rising_edge(clk)` is used rather than `wait for Xns`, this makes the simulation waveforms easier to read.

```VHDL
--reset
reset <= '1' after 1ns, '0' after 2ns;

--clock
clk <= not clk after 5ns;

--stimuli
process is
begin
    wait until rising_edge(clk);
    --stimuli 1...

    wait until rising_edge(clk);
    --and so on...
end process;
```

# Contributing Documentation
Documentation can refer to a README supplied with a module or its testbench. We expect contributors to provide documentation with their pull requests. However, we are aware that writing is not every developer's forte. Therefore, we also welcome improvements to the grammar, spelling, and clarity of any documentation. These improvements must not change the ideas communicated.

# Making a Pull Request
If there are multiple contributions you wish to make, we ask that these be sent in separate pull requests. Keeping pull requests clear and concise makes them easier to review. The process of making a pull request is as follows:
1. Fork this repository
2. Clone your fork

```bash
git clone <your-forks-URL>
```

3. Create a new branch

```bash
git checkout -b <new-feature-branch>
```

4. Make your changes

```bash
git add *
git commit -m <your-commit-message>
git push origin <new-feature-branch>
```

5. Submit your pull request from your forked repository