# Base ALU

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
This is the ALU used in Pomegranates base configuration. It is designed to help build understanding of how various logical and arithmetic operations are performed by processors. As such, the design is very simple. It performs what we will call "fundamental" logic and arithmetic operations.

We consider fundamental operations as those functions that require no extra logic except the simple machine required to perform it. For example, the multiplication of two 8-bit numbers results in a 16-bit number. Therefore, multiplication requires both the simple machine that performs it and extra logic to deal with the extra bits that we may not be able to store in one address space.

![ALU block diagram](https://github.com/Zachary-Pearce/Pomegranate/blob/main/images/ALU_Block_Diagram.png)

This is a purely combinational module that can perform the following operations:
* add
* subtract
* AND
* OR
* XOR
* NOT
* binary shifting

These functions were chosen to be implemented because they don't require multiple steps, a NAND operation could be implemented with one simple machine. However, this same function could also be implemented through an AND then a NOT instruction. The number of functions may at first seem limiting, however as described, multiple functions not included here can be performed through a series of instructions.

> [!NOTE]
> Simple machines are standard designs that are often put together to form a larger system. For example, an ALU in modern CPUs can be made of simple machines that each perform one kind of arithmetic.

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/ALU/)