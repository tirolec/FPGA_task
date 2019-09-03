# FPGA_task
 FPGA task about check connection between chips.
 
 In order to provide full test coverage we have to check connection between FPGA and FX3 chip.
 
There are several options how to implement such functionality with minimum efforts. FX3 GPIO module are very flexible so we’re going to put it in the simple GPIO mode. This will provide us ability to set any values at input pins of FX3, copy these values to the outputs using special FX3 firmware.

![Image alt](https://github.com/tirolec/FPGA_task/raw/master/images_for_readme/main.jpg)

Requirements:

* FPGA MUST provide clock frequency (40MHz) at the FX3_PCLK pin.
* FPGA MUST provide reset signal (active high) at the FX3_RST pin. Duration must be no less than 200us.
* FPGA MUST provide INTR signal (active edge is falling) at the FX3_GPIO23 to latch test data values in the FX3.
* FPGA MUST latch result values on the falling edge of FX3_GPIO26.
* FPGA MUST apply at least 4 different test pattern. 
* FPGA MUST apply each test pattern at least 1 times.
* FPGA MUST compare test and result values and put “pass” or “fail” to a special register. 
* FPGA MUST monitor USB_CABLE which informs about USB cable connection.
* FPGA MUST check FX3_GPIO57 pin if USB_CABLE is ‘1’ for 100us and copy its value to a special register.
* FPGA testbench SHOULD be provided.

![Image alt](https://github.com/tirolec/FPGA_task/raw/master/images_for_readme/table_1.jpg)
