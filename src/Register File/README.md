# Register File

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
The register file is a bank of registers with 2 read ports and 1 write port. This allows a source and target register to be read from at the same time as a desintation register is written to.

The read registers can be output through multiple ports, the source_out and target_out ports are meant to be connected directly to an ALUs input.

```VHDL
source_out <= registers(to_integer(unsigned(source_register)))(n-1 downto 0);
target_out <= registers(to_integer(unsigned(target_register)))(n-1 downto 0);
```

Where source_out outputs the contents of the source register and target_out outputs the contents of the target register.

This is done so that ALU operations on register contents don't have to use the databus until the result is output. This allows for a single clock cycle operation from fetching data to writing back to the register file.

The other output port is the data_bus, only the source register is sent through this port as it is assumed that the data bus is one word wide and therefore would be unable to fit both registers on the bus.

```VHDL
data_bus <= registers(to_integer(unsigned(source_register)))(n-1 downto 0) when data_bus_R_file = '1' else (others => 'Z');
```

### Scalability
The register file can be scaled by changing the width of the register addresses (denoted by the generic "k").

```VHDL
k: natural := 5
```

The nubmer of registers in the register file can be worked out using the follow equation:

```math
\text{Register No.} = 2^{k}
```

In the example value of k given above, this would be $2^{5} = 32$ registers. In the base configuration of Pomegranate, $k = 3$ and therefore there are $2^{3} = 8$ registers.

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/Register%20File).