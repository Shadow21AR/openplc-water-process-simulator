# OpenPLC Water Process Simulator

A simple Structured Text (ST) program for **OpenPLC Runtime** that simulates a continuously changing industrial water process.

The simulator was created for OT, ICS, and SCADA training environments where realistic Modbus TCP traffic is required without connecting physical industrial equipment.

The process continuously updates several variables such as tank level, temperature, flow rate, pressure, pump status, and alarm states. These variables are exposed as **Modbus Holding Registers**, making the simulator suitable for SCADA systems, protocol analyzers, and industrial cybersecurity laboratories.

---

## Features

- Simulated water tank
- Automatic filling and draining
- Pump control
- Inlet valve control
- High and low level alarms
- Oscillating temperature
- Simulated flow rate
- Simulated pressure
- Automatic operating mode

The process runs continuously without requiring user interaction.

---

## Register Map

| Modbus Register | PLC Address | Variable | Description |
|----------------:|------------|----------|-------------|
|1025|%MW0|TankLevel|Tank level (%)|
|1026|%MW1|Temperature|Water temperature (°C)|
|1027|%MW2|FlowRate|Flow rate|
|1028|%MW3|Pressure|Pressure|
|1029|%MW4|PumpRunning|Pump running state|
|1030|%MW5|InletValve|Inlet valve state|
|1031|%MW6|HighAlarm|High level alarm|
|1032|%MW7|LowAlarm|Low level alarm|
|1033|%MW8|AutoMode|Automatic operating mode|

---

## Process Behaviour

The simulated process performs the following operations:

1. The tank starts at approximately **60%** capacity.
2. The inlet valve fills the tank.
3. When the level reaches **90%**, the inlet valve closes.
4. The pump starts draining the tank.
5. When the level falls to **20%**, the pump stops.
6. The inlet valve opens again.
7. Temperature continuously oscillates between **25°C** and **30°C**.
8. Flow rate and pressure automatically change based on the pump state.

This cycle repeats indefinitely.

---

## Modbus TCP

The OpenPLC Runtime exposes these values using Modbus TCP.

Default configuration:

- Protocol: Modbus TCP
- TCP Port: **502**
- Unit ID: **1**

Example using `mbpoll`:

```bash
mbpoll -m tcp -t 4 -r 1025 -c 9 192.168.100.10
```

Example output:

```
1025  73
1026  28
1027  40
1028 120
1029   1
1030   0
1031   0
1032   0
1033   1
```

---

## Typical Use Cases

- Rapid SCADA demonstrations
- Modbus TCP learning
- Wireshark protocol analysis
- OT cybersecurity labs
- Industrial protocol testing
- OpenPLC practice environments

---

## Compatibility

Tested with:

- OpenPLC Runtime v3
- Modbus TCP
- Rapid SCADA 6
- mbpoll
- Wireshark

---

## License

MIT License
