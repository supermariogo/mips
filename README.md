MIPS Plasma
====================================================================================================

32 bits MIPS processor  implementation on Xilinx Sparten 3E

Support all MIPS user mode instructions except unaligned load and store operations

3 stages pipeline and direct-mapped 1 level cache

Peripherals including interrupt controller, UART, SRAM or DDR SDRAM controller and Ethernet controller 

Synthesis on Xilinx Spartan 3E

Boot loader for ELF programs and kernel

Real time operating system running on it


The project is based on opensource project Plasma and implements a MIPS instruction set compatible processor.

From http://opencores.org/project,plasma,overview

The includes MIPS processor sofeware modeling, hardware implementation and system level verification.

First, software model. The model is designed in high level language(C) and runs on PC. With the assistance of the model, deigner can conduct a feasibility analysis before the hardware impentation. The model is also a CPU simulator, which can run and debug MIPS programs. 

Second, hardware implantation: processor core, memory controller and I/O devices interfaces are introduced. The pipeline design, cache control and exception mechanism are also involed in this section.    

Third, sytem-level verification. In this secion, three verification schemes are provided to verify the whole project. They are CPU simulator verifcaiton, hardware simulation and FPGA test. 

Finally, a real time operating system is deployed on the FPGA board, controlling all the hardware resources.

