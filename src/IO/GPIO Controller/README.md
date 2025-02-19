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

### Port Output Logic

### Port Inputs Logic

### Limitations

## Testing
Information surrounding the testing of this module can be found [here](https://github.com/Zachary-Pearce/Pomegranate/blob/main/testing/IO/GPIO%20Controller).