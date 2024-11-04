# Base ALU

## Design and Justification
This is the ALU used in Pomegranates base configuration. It can perform what could could be considered fundamental logic and arithmetic operations with support for immediate addressing. The figure below shows the ALU block diagram.

![ALU block diagram](https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/Basic_ALU_Block_Diagram.jpg)

This module is designed just to perform the very basic operations:
* add
* subtract
* AND
* OR
* XOR
* NOT
* binary shifting

This functionality was chosen because they require no extra logic except the simple machines required to perform the function, for example multipliers require both a simple machine to perform the multiplication and a way to deal with the output width being the sum of the input widths.

> [!NOTE]
> Simple machines are standard designs that are often put together to form a larger system. For example, an ALU in modern CPUs is made of simple machines that each perform one kind of arithmetic.

## Testing
The test README can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/ALU/README.md)