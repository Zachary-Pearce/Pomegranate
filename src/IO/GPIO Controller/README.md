# GPIO Controller

## Design and Justification
<!-- Please discuss your design here -->
<!-- Make sure to justify any design choices made where there may be an alternative approach -->
This module is a scaleable GPIO controller that has input/output capabilities on a number of pins that are organised into ports. The GPIO is described by several parameters:
* `PIN_NUM` - The number of I/O pins.
* `WORD_WIDTH` - The number of I/O pins per port, also the width of the data bus.
* `REGISTER_ADDRESS_WIDTH` - The width of the register addresses used to reference the control and I/O registers.
* `DDR_REG_LOCATION` - Keeps track of the index of the first Data Direction Register (DDR).

The first three of these parameters are defined by a generic map where as `DDR_REG_LOCATION` is defined through a constant. Each port has an input and an output buffer that is `WORD_WIDTH` wide. Where the number of ports is given by the equation:

$$\text{Port Num.} = \frac{\text{PIN NUM}}{\text{WORD WIDTH}}$$

For each port, there are various registers, such as:
* Input buffer
* Output buffer
* DDR

However, there can be more control registers for the purpose of other functions such as determining interrupt behaviour. The `REGISTER_ADDRESS_WIDTH` is used to determine the maximum number of addressable registers in the GPIO controller. Following the equation:

$$\text{Register Num.} = 2^{\text{REGISTER ADDRESS WIDTH}}$$

At a minimum, there must be enough addressable registers to support the three listed registers for each port.

### Port Output Logic
The following code shows the generate statement that creates the output logic. It loops through each port and their pins, creating a tri-state connection from the output buffer to the relevant pin where the enable signal is provided by the data direction register for that port.

```VHDL
gen_output_port: for ii in 0 to (PIN_NUM/WORD_WIDTH)-1 generate
    gen_output_pin: for jj in 0 to WORD_WIDTH-1 generate
        pins(jj+(ii*WORD_WIDTH)) <= IO_registers(ii+PIN_NUM/WORD_WIDTH)(jj) when IO_registers(ii+DDR_REG_LOCATION)(jj) = '1' else 'Z';
    end generate gen_output_pin;
end generate gen_output_port;
```

### Port Input Logic
The input logic is done sequentially within the process `s0`. When the `CS` input is driven low, the bits of the input buffers are written with the values of the input pins when the relevant bit of the data direction register is cleared. If any of the other pins in the port are set to be outputs (according to the DDR) then those corresponding buffer bits are cleared rather than written to.

```VHDL
if (CS = '1') then
    ...
else
    for ii in 0 to (PIN_NUM/WORD_WIDTH)-1 loop
        for jj in 0 to WORD_WIDTH-1 loop
            if IO_registers(ii+DDR_REG_LOCATION)(jj) = '0' then
                IO_registers(ii)(jj) <= pins(jj+(ii*WORD_WIDTH));
            else
                IO_registers(ii)(jj) <= '0';
            end if;
        end loop;
    end loop;
end if;
```

### Configuration Rules
Because each of the registers in a GPIO controller have a special purpose, they make scaleability tricky because we can't just increase the size of the register file and put them wherever we want. For example, we need to reference each of the DDRs so we need to know where they are in the register file. As such, some rules have to be followed in order for the design to keep its scaleability.

1. `PIN_NUM` must be greater than or equal to the `WORD_WIDTH`.
2. `REGISTER_ADDRESS_WIDTH` must support enough registers for each port to have an input buffer, output buffer, and DDR.
3. `DDR_REG_LOCATION` must indicate a DDR index that is after all input/output ports.
4. All DDRs must be contiguous in the register file, starting with the one marked by `DDR_REG_LOCATION`.
5. All input buffers must be the first reigsters in the file and are contiguous in numerical order (e.g. Port 1 then Port 2 or Port A then Port B).
6. Output buffers come immediately after the input buffers are contiguous in numerical order.

The table below shows an example of a valid configuration where:
* `WORD_WIDTH` = 8
* `PIN_NUM` = 16
* `DDR_REG_LOCATION` = 4
* `REGISTER_ADDRESS_WIDTH` = 3

| RS    | Name      | Description               |
| :---: | --------- | ------------------------- |
| 0     | A_in_reg  | Input buffer A            |
| 1     | B_in_reg  | Input buffer B            |
| 2     | A_out_reg | Output buffer A           |
| 3     | B_out_reg | Output buffer B           |
| 4     | DDRA      | Data direction register A |
| 5     | DDRB      | Data direction register B |
| 6     | ...       | ...                       |
| 7     | ...       | ...                       |

### Limitations

* The input buffers cannot read from input pins while other registers are being accessed. In order for an input pins value to be stored in an input buffer, `CS` must be driven low.
* When a value is written to an output register, it will be present at the output pins in the next clock cycle.

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/IO/GPIO%20Controller).