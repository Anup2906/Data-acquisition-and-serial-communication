# Real-Time Data Acquisition System using Arduino (ATmega328P)

## Overview

This project involves the design and development of a **real-time data acquisition system** using an Arduino-based microcontroller (**ATmega328P**) for logging analog telemetry signals onto an **SD card**.

## Key Features

- **Microcontroller**: ATmega328P (Arduino)
- **Data Storage**: SD card (FAT16/FAT32)
- **Interface Protocol**: SPI (Serial Peripheral Interface)
- **Sensor Input**: Built-in ADC (Analog-to-Digital Converter)
- **Data Format**: Structured `.csv` file format
- **Timestamping**: Real-time timestamping for each data entry
- **Data Integrity**: Ensures minimal latency and high reliability
- **Post-Processing**: MATLAB used for waveform analysis and integrity verification

## System Architecture

- The ATmega328P continuously samples analog signals via its internal ADC.
- Acquired data is transferred to the SD card using the **SPI** protocol.
- Logged data is structured in a `.csv` format, enabling easy post-processing.
- The system is capable of continuous logging under real-time constraints.
- Designed for **robust, portable, and non-volatile telemetry data capture**.

## Application

This system is particularly suited for **dynamic testing environments**, such as **missile telemetry subsystems**, where **robust and accurate embedded data logging** is critical.

## Tools Used

- **Arduino IDE** – Firmware development
- **MATLAB** – Data analysis and verification
- **SPI Library** – Communication with SD card
- **SD Library** – File system support (FAT16/FAT32)

---

> 📌 This project enhances embedded storage solutions in telemetry systems requiring high-speed, non-volatile logging capabilities.
