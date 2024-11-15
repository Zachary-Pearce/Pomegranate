# Stack Pointer

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
The stack is a FILO data structure stored in main memory. The stack pointer points to the top of the stack. This means, the stack pointer is a simple register with the ability to increment or decrement it's value depending on if a value is pushed onto or popped off the top of the stack.

Line 46 of the code as shown below:

```VHDL
    address <= std_logic_vector(pointer_reg) when enable = '1' and Pntr_INC = '1' else (others => 'Z');
```

is how the value of the stack pointer is output when a value is pushed onto the stack, it is done this way because we need to output the value of the stack pointer before it is incremented this is because in actually the stack pointer points to the address space after the top of the stack.

This implementation also requires some extra logic when popping off the top of the stack. As the stack pointer points to the address after the top, we need to decrement it when we output it so it outputs the address of the top of the stack.

```VHDL
    address <= std_logic_vector(pointer_reg-1) when enable = '1' and Pntr_INC = '0' else (others => 'Z');
```

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/Stack%20Pointer/).