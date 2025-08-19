# Stack Pointer

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
The stack is a FILO data structure stored in main memory. The stack pointer points to the top of the stack. It is a simple register with the ability to increment or decrement its value depending on if a value is pushed onto or popped off the top of the stack.

![Stack block diagram](/images/Stack_Pointer_Block_Diagram.png)

### Incrementation and Decrementation
This stack pointer is designed to function within a clock cycle. In VHDL, signals that are assigned a value inside of a process take a clock cycle to settle. Therefore, whenever we access the stack pointer, we need to increment/decrement it at the same, this is done through 2 signals.

```VHDL
--stack pointer register
signal pointer_reg: unsigned(a-1 downto 0);
--next pointer value
signal pointer_reg_next: unsigned(a-1 downto 0);
```

`pointer_reg` is the current value of the stack pointer and `pointer_reg_next` is the next value. `pointer_reg` is output as the current value while `pointer_reg_next` is assigned the new value inside of the process shown below.

```VHDL
--SEQUENTIAL PART
s0: process (CLK, RST) is
begin
    if RST = '1' then
        pointer_reg_next <= starting_address;
    elsif rising_edge(CLK) then
        if (enable = '1') then
            if (Pntr_INC = '1') then
                pointer_reg_next <= pointer_reg + 1;
            else
                pointer_reg_next <= pointer_reg - 1;
            end if;
        end if;
    end if;
end process s0;
```

Outside of the process, `pointer_reg` is assigned the value of `pointer_reg_next` in a combinational statement.

```VHDL
pointer_reg <= pointer_reg_next;
```

In the current clock cycle, this will assign the current value of the pointer to `pointer_reg` because the new value hasn't settled in `pointer_reg_next` yet. In the next clock cycle, this will assign the new value to `pointer_reg` because the new value of `pointer_reg_next` will have settled.

### Output logic
Line 46 of the code as shown below is how the value of the stack pointer is output when a value is pushed onto the stack, the pointer actually points to the address after the top of the stack, so `pointer_reg` is output as the memory address of the data to be pushed onto the stack.

```VHDL
address <= std_logic_vector(pointer_reg) when enable = '1' and Pntr_INC = '1' else (others => 'Z');
```

This implementation also requires some extra logic when popping off the top of the stack. As the stack pointer points to the address after the top, we need to decrement it so the address of the top of the stack is output.

```VHDL
address <= std_logic_vector(pointer_reg-1) when enable = '1' and Pntr_INC = '0' else (others => 'Z');
```

## Configuration
The `a` parameter represents the width of the stack pointer, this is typically the same size as the memory address width. However, the stacks height can be restricted to only a number of memory addresses.

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/Stack%20Pointer/).