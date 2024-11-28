# Base ALU

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
This is the ALU used in Pomegranates base configuration. It performs what could be considered fundamental logic and arithmetic operations with support for immediate addressing. The figure below shows the ALU block diagram.

![ALU block diagram](https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/Basic_ALU_Block_Diagram.jpg)

This is a purely combinational module that is designed to perform the following fundamental logic and arithemetic operations:
* add
* subtract
* AND
* OR
* XOR
* NOT
* binary shifting

We consider fundamental operations as those functions that require no extra logic except the simple machine required to perform it, for example multipliers require both a simple machine to perform the multiplication and a way to deal with the extra bits that we may not be able to store as the output width will be the sum of the input widths.

These fundamental operations were chosen because they are common and can be used to implement more complex functions, especially for arithmetic, for example multiplication can be implemented through repeated addition.

> [!NOTE]
> Simple machines are standard designs that are often put together to form a larger system. For example, an ALU in modern CPUs is made of simple machines that each perform one kind of arithmetic.

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/ALU/)