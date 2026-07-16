(*
    ============================================================================
    OpenPLC Water Process Simulator
    ============================================================================

    Description
    -----------
    This program simulates a simple water treatment process for OT and SCADA
    training environments.

    It generates continuously changing process values that can be monitored
    using Modbus TCP clients such as Rapid SCADA, mbpoll, Wireshark, and other
    industrial monitoring tools.

    Modbus Holding Registers

      %MW0  (1025) TankLevel
      %MW1  (1026) Temperature
      %MW2  (1027) FlowRate
      %MW3  (1028) Pressure
      %MW4  (1029) PumpRunning
      %MW5  (1030) InletValve
      %MW6  (1031) HighAlarm
      %MW7  (1032) LowAlarm
      %MW8  (1033) AutoMode

    ============================================================================
*)

PROGRAM prog0

VAR
    TankLevel    AT %MW0 : INT;
    Temperature  AT %MW1 : INT;
    FlowRate     AT %MW2 : INT;
    Pressure     AT %MW3 : INT;
    PumpRunning  AT %MW4 : INT;
    InletValve   AT %MW5 : INT;
    HighAlarm    AT %MW6 : INT;
    LowAlarm     AT %MW7 : INT;
    AutoMode     AT %MW8 : INT;
END_VAR

VAR
    Initialized   : BOOL;
    TempDirection : INT;
    TempCounter   : INT;
END_VAR


(* ---------------------------------------------------------- *)
(* Initialization                                              *)
(* ---------------------------------------------------------- *)

IF NOT Initialized THEN

    TankLevel := 60;
    Temperature := 25;

    FlowRate := 10;
    Pressure := 90;

    PumpRunning := 0;
    InletValve := 1;

    HighAlarm := 0;
    LowAlarm := 0;

    AutoMode := 1;

    TempDirection := 1;
    TempCounter := 0;

    Initialized := TRUE;

END_IF;


(* ---------------------------------------------------------- *)
(* Automatic Process Control                                  *)
(* ---------------------------------------------------------- *)

IF AutoMode = 1 THEN

    IF TankLevel >= 90 THEN

        PumpRunning := 1;
        InletValve := 0;
        HighAlarm := 1;

    END_IF;

    IF TankLevel <= 20 THEN

        PumpRunning := 0;
        InletValve := 1;
        LowAlarm := 1;

    END_IF;

END_IF;


(* ---------------------------------------------------------- *)
(* Tank Simulation                                             *)
(* ---------------------------------------------------------- *)

IF InletValve = 1 THEN
    TankLevel := TankLevel + 1;
END_IF;

IF PumpRunning = 1 THEN
    TankLevel := TankLevel - 1;
END_IF;


IF TankLevel > 100 THEN
    TankLevel := 100;
END_IF;

IF TankLevel < 0 THEN
    TankLevel := 0;
END_IF;


(* ---------------------------------------------------------- *)
(* Alarm Logic                                                 *)
(* ---------------------------------------------------------- *)

HighAlarm := 0;
LowAlarm := 0;

IF TankLevel >= 90 THEN
    HighAlarm := 1;
END_IF;

IF TankLevel <= 20 THEN
    LowAlarm := 1;
END_IF;


(* ---------------------------------------------------------- *)
(* Flow Rate                                                   *)
(* ---------------------------------------------------------- *)

IF PumpRunning = 1 THEN
    FlowRate := 40;
ELSE
    FlowRate := 10;
END_IF;


(* ---------------------------------------------------------- *)
(* Pressure                                                    *)
(* ---------------------------------------------------------- *)

Pressure := 80 + FlowRate;


(* ---------------------------------------------------------- *)
(* Temperature                                                 *)
(* ---------------------------------------------------------- *)

TempCounter := TempCounter + 1;

IF TempCounter >= 50 THEN

    TempCounter := 0;

    Temperature := Temperature + TempDirection;

    IF Temperature >= 30 THEN
        Temperature := 30;
        TempDirection := -1;
    END_IF;

    IF Temperature <= 25 THEN
        Temperature := 25;
        TempDirection := 1;
    END_IF;

END_IF;


END_PROGRAM


CONFIGURATION Config0

RESOURCE Res0 ON PLC

    TASK Main(INTERVAL := T#100ms, PRIORITY := 0);

    PROGRAM Inst0 WITH Main : prog0;

END_RESOURCE

END_CONFIGURATION
