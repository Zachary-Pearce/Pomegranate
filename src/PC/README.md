# Program Counter

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
The program counter (PC) is a register that holds the address of the current instruction being executed.

![Program counter block diagram](/images/Program_Counter_Block_Diagram.png)

### Counter Logic
This program counter is designed to function within a clock cycle, meaning the value of the program counter must be read at the same time as being incremented. To make this possible two signals were used, `counter_reg` and `counter_next`.

```VHDL
signal counter_reg, counter_next: unsigned(a-1 downto 0);
```

`counter_reg` holds the current value of the program counter, while `counter_next` is used to compute the next value. The clocked process shown below is why we need these two signals, assigning `counter_next` a value within this process takes two clock cycles. Or in other words, the new value of `counter_next` will not be available until the process is run again.

```VHDL
s0: process (CLK, RST) is
begin
    if RST = '1' then
        counter_next <= to_unsigned(1, 8);
    elsif rising_edge(CLK) then
        --increment counter register
        if PC_INC = '1' then
            counter_next <= counter_reg + 1;
        --otherwise load a value into the program counter...
        elsif PC_LDA = '1'  then
            --from the data bus
            counter_next <= unsigned(data_bus);
        else
            --from the instruction bus
            counter_next <= unsigned(instruction_bus);
        end if;
    end if;
end process s0;
```

If we just had `counter_reg`, you can see how each count would take two clock cycles, one clock cyle to increment and the next clock cycle to output. `counter_reg` is only assigned values outside of the process, more specifically line 43:

```VHDL
counter_reg <= counter_next;
```

On any given clock cycle, this will use the old value of `counter_next`, meaning this line assigns `counter_reg` the current value of the counter and on the following clock cycle, the new value of `counter_next` will have settled and be assigned to `counter_reg`.

### Output Logic
In order to support subroutine calls and returns, there needs to be a way to put the value of the program counter on the data bus so it can be stored in the stack.

```VHDL
data_bus <= std_logic_vector(counter_reg+1) when DAT_PC = '1' else (others => 'Z');
```

This is done as above. We output an incremented `counter_reg` here because otherwise when returning from a subroutine we would return to and run the line where we called the subroutine. Creating an infinite loop.

## Configuration
This module offers limited configuration, the `a` parameter represents the width of the program counter and can be changed to match the width of the relevant memory address space. This can be set to any value.

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/PC/).
