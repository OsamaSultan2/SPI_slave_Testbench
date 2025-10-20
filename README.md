# SPI_slave_Testbench
# UVM-Based SPI Slave Verification Project

![Language](https://img.shields.io/badge/Language-SystemVerilog-blue.svg)
![Methodology](https://img.shields.io/badge/Methodology-UVM-green.svg)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen.svg)

## 📖 Overview

This repository presents a comprehensive verification environment for a **Serial Peripheral Interface (SPI) Slave** design, built entirely using the **Universal Verification Methodology (UVM)**. This project serves as a practical demonstration of applying advanced UVM concepts such as sequence-item-sequences, configuration objects, callbacks, and objections for robust and scalable verification.

The goal is to ensure the SPI Slave DUT correctly interprets and responds to SPI Master commands, handles various data lengths, and manages its internal state transitions.

---

## 📝 SPI Slave Design Features (DUT)

The Design Under Test (DUT) is a configurable SPI Slave module with the following expected features:

* **Data Frame Size**: Configurable from `[8-bit]`
* **Slave Select (CSB)**: Active-low chip select.
* **Data Transfer**: Serial data in (MOSI) and serial data out (MISO).
* **Shift Register**: Internal logic to manage serial-to-parallel conversion on MOSI and parallel-to-serial conversion on MISO.

---

## 🏗️ UVM Verification Environment Architecture

The UVM testbench is structured hierarchically, following best practices for modularity and reusability.

* **`spi_transaction`**: The fundamental sequence item representing a single SPI transfer (e.g., MOSI data, MISO expected data, control signals).
* **`spi_sequencer`**: Orchestrates the flow of `spi_transaction` items from sequences to the driver.
* **`spi_driver`**: Translates `spi_transaction` items into pin-level toggles on the virtual interface.
* **`spi_monitor`**: Observes the virtual interface, captures pin-level activity, and converts it back into `spi_transaction` items for analysis.
* **`spi_agent`**: Encapsulates the sequencer, driver, and monitor. Configurable for active (driving) or passive (monitoring only) modes.
* **`spi_scoreboard`**: Compares transactions observed by the monitor (actual) with expected transactions (from a reference model or functional coverage collector).
* **`spi_env`**: Contains one or more `spi_agent` instances, the `spi_scoreboard`, and any other environment-level components (e.g., functional coverage collector, reference model).
* **`spi_base_test`**: The top-level UVM test class, which builds the `spi_env` and starts sequences.
* **Sequences**: Define stimulus scenarios by generating `spi_transaction` items. Includes basic read/write, burst transfers, error injection, etc.
* **Configuration Objects (`uvm_config_db`)**: Used to configure agents and other components during the build phase (e.g., setting agent mode, virtual interface handles).
* **Virtual Interface**: Connects the testbench components to the physical DUT ports, encapsulating signal connections and clocking blocks.
