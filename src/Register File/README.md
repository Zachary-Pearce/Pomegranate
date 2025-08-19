# Register File

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
The register file is a bank of registers with 2 read ports and 1 write port. This allows a source and target register to be read from at the same time as a destination register is written to. This particular register file is designed for single cycle operation.

The source register can be output through multiple ports:
1. `source_out`
2. `data_bus`

The target register is output through the `target_out` port. This behaviour is described by the output part shown below.

```VHDL
--OUTPUT PART
source_out <= registers(to_integer(unsigned(source_register)))(WORD_WIDTH-1 downto 0);
target_out <= registers(to_integer(unsigned(target_register)))(WORD_WIDTH-1 downto 0);
data_bus <= registers(to_integer(unsigned(source_register)))(WORD_WIDTH-1 downto 0) when data_bus_R_file = '1' else (others => 'Z');
```

This setup is used so that ALU operations on register contents don't have to use the data bus until the result is output. This allows for a single clock cycle operation from fetching data to writing back to the register file.

The `data_bus` is only driven by the source register as it is assumed that the registers and `data_bus` are both one word wide. However, this logic can be changed to be driven by both registers if this is not the case.

## Configuration
The register file can be configured using the following parameters:
* `WORD_WIDTH` - Determines the width of the registers and `data_bus` port.
* `REG_ADDRESS_WIDTH` - Determines the width of the register addresses.

The number of registers in the register file can be worked out using the following equation:

```math
\text{Register No.} = 2^{\text{REG ADDRESS WIDTH}}
```

For the default value of `REG_ADDRESS_WIDTH` (5), this would be $2^{5} = 32$ registers.

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/Register%20File).