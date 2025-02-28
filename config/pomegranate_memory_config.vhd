----------------------------------------------------------------------------------
-- Engineer: Zachary Pearce
-- 
-- Create Date: 28/02/2025
-- Module Name: pomegranate_memory_conf
-- Project Name: Pomegranate
-- Description: Define parameters that are used to modify the memory map of the architecture
-- 
-- Dependencies: NA
-- 
-- Revision: 1.0
-- Revision Date: 28/02/2025
-- Notes: File Created
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pomegranate_memory_conf is
    ---- VARIABLE TYPES ----

    -- a list of devices memory addresses are mapped to
    type devices is
    (
        RAM,
        GPIO
    );

    -- a list of main memory partitions
    type partitions is
    (
        zero_page,
        stack,
        program_start
    );

    -- array type for mapping a number of addresses to a device
    type device_addresses_array is array (devices) of natural;

    -- memory partitions aren't necessarily contiguous so we need to keep track of both their width and their starting address

    -- array type for the number of addresses in a memory partition
    type memory_partition_width_array is array (partitions) of natural;

    -- array type for the starting addresse of a memory partition
    type memory_partition_address_array is array (partitions) of natural;

    ---- FUNCTION DECLARATIONS ----
    
    -- function for finding the starting address of a memory mapped device
    function find_device_address (device: in devices) return natural;
end package pomegranate_memory_conf;

package body pomegranate_memory_conf is
    ---- VARIABLES ----

    -- constant array to hold the number of addresses mapped to a device
    constant DEVICE_ADDRESSES: device_addresses_array := (
        36863,
        28672
    );

    -- constant array to hold the number of address in a memory partition
    constant MEMORY_PARTITION_WIDTH: memory_partition_width_array := (
        256,
        256,
        1
    );

    -- constant array to hold the starting address of a memory partition
    constant MEMORY_PARTITION_ADDRESS: memory_partition_address_array := (
        0,
        256,
        512
    );

    ---- FUNCTIONS ----

    -- function for finding the starting address of a memory mapped device
    function find_device_address (device: in devices := devices(0)) return natural is
        variable address: natural := 0;
    begin
        if device'pos > 0 then --if this is not the first device...
            -- add up the number of addresses in previous devices to get the starting address
            for d in range 0 to device'pos-1 loop
                address := address + DEVICES_ADDRESSES(device);
            end loop;
        else -- otherwise the starting address is 0
            address := 0
        end if;

        return address;
    end function find_device_address;
end package body pomegranate_memory_conf;