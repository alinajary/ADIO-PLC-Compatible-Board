
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATxmega64A3U
;Program type           : Application
;Clock frequency        : 32.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATxmega64A3U
	#pragma AVRPART MEMORY PROG_FLASH 69632
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x2000

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU CCP=0x34
	.EQU RAMPD=0x38
	.EQU RAMPX=0x39
	.EQU RAMPY=0x3A
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU WDT_CTRL=0x80
	.EQU PMIC_CTRL=0xA2
	.EQU NVM_ADDR0=0X01C0
	.EQU NVM_ADDR1=NVM_ADDR0+1
	.EQU NVM_ADDR2=NVM_ADDR1+1
	.EQU NVM_DATA0=NVM_ADDR0+4
	.EQU NVM_CMD=NVM_ADDR0+0xA
	.EQU NVM_CTRLA=NVM_ADDR0+0xB
	.EQU NVM_CTRLB=NVM_ADDR0+0xC
	.EQU NVM_STATUS=NVM_ADDR0+0xF
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIO0=0x00
	.EQU GPIO1=0x01
	.EQU GPIO2=0x02
	.EQU GPIO3=0x03
	.EQU GPIO4=0x04
	.EQU GPIO5=0x05
	.EQU GPIO6=0x06
	.EQU GPIO7=0x07
	.EQU GPIO8=0x08
	.EQU GPIO9=0x09
	.EQU GPIO10=0x0A
	.EQU GPIO11=0x0B
	.EQU GPIO12=0x0C
	.EQU GPIO13=0x0D
	.EQU GPIO14=0x0E
	.EQU GPIO15=0x0F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x2000
	.EQU __SRAM_END=0x2FFF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _DAQ_data=R2
	.DEF _DAQ_data_msb=R3
	.DEF _start_byte=R5
	.DEF _stop_byte=R4
	.DEF _flag=R6
	.DEF _flag_msb=R7
	.DEF _data_recieved=R8
	.DEF _data_recieved_msb=R9
	.DEF _packet_start=R10
	.DEF _packet_start_msb=R11
	.DEF _DAC_data=R12
	.DEF _DAC_data_msb=R13

;GPIO0-GPIO15 INITIALIZATION VALUES
	.EQU __GPIO0_INIT=0x00
	.EQU __GPIO1_INIT=0x00
	.EQU __GPIO2_INIT=0x00
	.EQU __GPIO3_INIT=0x00
	.EQU __GPIO4_INIT=0x00
	.EQU __GPIO5_INIT=0x00
	.EQU __GPIO6_INIT=0x00
	.EQU __GPIO7_INIT=0x00
	.EQU __GPIO8_INIT=0x00
	.EQU __GPIO9_INIT=0x00
	.EQU __GPIO10_INIT=0x00
	.EQU __GPIO11_INIT=0x00
	.EQU __GPIO12_INIT=0x00
	.EQU __GPIO13_INIT=0x00
	.EQU __GPIO14_INIT=0x00
	.EQU __GPIO15_INIT=0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION VALUES
	.EQU __R2_INIT=0x00
	.EQU __R3_INIT=0x00
	.EQU __R4_INIT=0xBB
	.EQU __R5_INIT=0xAA
	.EQU __R6_INIT=0x00
	.EQU __R7_INIT=0x00
	.EQU __R8_INIT=0x00
	.EQU __R9_INIT=0x00
	.EQU __R10_INIT=0x00
	.EQU __R11_INIT=0x00
	.EQU __R12_INIT=0x00
	.EQU __R13_INIT=0x00
	.EQU __R14_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usartf0_rx_isr
	JMP  0x00
	JMP  _usartf0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

__RESET:
	CLI
	CLR  R30

;MEMORY MAPPED EEPROM ACCESS IS USED
	LDS  R31,NVM_CTRLB
	ORI  R31,0x08
	STS  NVM_CTRLB,R31

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,0xD8
	OUT  CCP,R31
	STS  PMIC_CTRL,R30

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GPIO0-GPIO15 INITIALIZATION
	LDI  R30,__GPIO0_INIT
	OUT  GPIO0,R30
	;__GPIO1_INIT = __GPIO0_INIT
	OUT  GPIO1,R30
	;__GPIO2_INIT = __GPIO0_INIT
	OUT  GPIO2,R30
	;__GPIO3_INIT = __GPIO0_INIT
	OUT  GPIO3,R30
	;__GPIO4_INIT = __GPIO0_INIT
	OUT  GPIO4,R30
	;__GPIO5_INIT = __GPIO0_INIT
	OUT  GPIO5,R30
	;__GPIO6_INIT = __GPIO0_INIT
	OUT  GPIO6,R30
	;__GPIO7_INIT = __GPIO0_INIT
	OUT  GPIO7,R30
	;__GPIO8_INIT = __GPIO0_INIT
	OUT  GPIO8,R30
	;__GPIO9_INIT = __GPIO0_INIT
	OUT  GPIO9,R30
	;__GPIO10_INIT = __GPIO0_INIT
	OUT  GPIO10,R30
	;__GPIO11_INIT = __GPIO0_INIT
	OUT  GPIO11,R30
	;__GPIO12_INIT = __GPIO0_INIT
	OUT  GPIO12,R30
	;__GPIO13_INIT = __GPIO0_INIT
	OUT  GPIO13,R30
	;__GPIO14_INIT = __GPIO0_INIT
	OUT  GPIO14,R30
	;__GPIO15_INIT = __GPIO0_INIT
	OUT  GPIO15,R30

;GLOBAL REGISTER VARIABLES INITIALIZATION
	LDI  R30,__R4_INIT
	MOV  R4,R30
	LDI  R30,__R5_INIT
	MOV  R5,R30
	LDI  R30,__R6_INIT
	MOV  R6,R30
	;__R7_INIT = __R6_INIT
	MOV  R7,R30
	;__R8_INIT = __R6_INIT
	MOV  R8,R30
	;__R9_INIT = __R6_INIT
	MOV  R9,R30
	;__R10_INIT = __R6_INIT
	MOV  R10,R30
	;__R11_INIT = __R6_INIT
	MOV  R11,R30
	;__R12_INIT = __R6_INIT
	MOV  R12,R30
	;__R13_INIT = __R6_INIT
	MOV  R13,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x2400

	.CSEG
;// I/O Registers definitions
;#include <io.h>
;#include <delay.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;unsigned int DAQ_data = 0;
;float f_DAQ_data = 0;
;unsigned char start_byte=0xAA;
;unsigned char stop_byte=0xBB;
; int flag;
;char requ_buffer[14];
;#define packet_size_request     12
;unsigned int data_recieved;
;unsigned int packet_start;
;unsigned int DAC_data;
;
;// Declare your global variables here
;void dacb_write(unsigned char ch, unsigned int data);
;// System Clocks initialization
;void system_clocks_init(void)
; 0000 0016 {

	.CSEG
_system_clocks_init:
; .FSTART _system_clocks_init
; 0000 0017 unsigned char n,s;
; 0000 0018 
; 0000 0019 // Optimize for speed
; 0000 001A #pragma optsize-
; 0000 001B // Save interrupts enabled/disabled state
; 0000 001C s=SREG;
	ST   -Y,R17
	ST   -Y,R16
;	n -> R17
;	s -> R16
	IN   R16,63
; 0000 001D // Disable interrupts
; 0000 001E #asm("cli")
	cli
; 0000 001F 
; 0000 0020 // Internal 32 MHz RC oscillator initialization
; 0000 0021 // Enable the internal 32 MHz RC oscillator
; 0000 0022 OSC.CTRL|=OSC_RC32MEN_bm;
	LDS  R30,80
	ORI  R30,2
	STS  80,R30
; 0000 0023 
; 0000 0024 // System Clock prescaler A division factor: 1
; 0000 0025 // System Clock prescalers B & C division factors: B:1, C:1
; 0000 0026 // ClkPer4: 32000.000 kHz
; 0000 0027 // ClkPer2: 32000.000 kHz
; 0000 0028 // ClkPer:  32000.000 kHz
; 0000 0029 // ClkCPU:  32000.000 kHz
; 0000 002A n=(CLK.PSCTRL & (~(CLK_PSADIV_gm | CLK_PSBCDIV1_bm | CLK_PSBCDIV0_bm))) |
; 0000 002B 	CLK_PSADIV_1_gc | CLK_PSBCDIV_1_1_gc;
	LDS  R30,65
	ANDI R30,LOW(0x80)
	MOV  R17,R30
; 0000 002C CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 002D CLK.PSCTRL=n;
	STS  65,R17
; 0000 002E 
; 0000 002F // Disable the auto-calibration of the internal 32 MHz RC oscillator
; 0000 0030 DFLLRC32M.CTRL&= ~DFLL_ENABLE_bm;
	LDS  R30,96
	ANDI R30,0xFE
	STS  96,R30
; 0000 0031 
; 0000 0032 // Wait for the internal 32 MHz RC oscillator to stabilize
; 0000 0033 while ((OSC.STATUS & OSC_RC32MRDY_bm)==0);
_0x3:
	LDS  R30,81
	ANDI R30,LOW(0x2)
	BREQ _0x3
; 0000 0034 
; 0000 0035 // Select the system clock source: 32 MHz Internal RC Osc.
; 0000 0036 n=(CLK.CTRL & (~CLK_SCLKSEL_gm)) | CLK_SCLKSEL_RC32M_gc;
	LDS  R30,64
	ANDI R30,LOW(0xF8)
	ORI  R30,1
	MOV  R17,R30
; 0000 0037 CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 0038 CLK.CTRL=n;
	STS  64,R17
; 0000 0039 
; 0000 003A // Disable the unused oscillators: 2 MHz, internal 32 kHz, external clock/crystal oscillator, PLL
; 0000 003B OSC.CTRL&= ~(OSC_RC2MEN_bm | OSC_RC32KEN_bm | OSC_XOSCEN_bm | OSC_PLLEN_bm);
	LDS  R30,80
	ANDI R30,LOW(0xE2)
	STS  80,R30
; 0000 003C 
; 0000 003D // ClkPer output disabled
; 0000 003E PORTCFG.CLKEVOUT&= ~(PORTCFG_CLKOUTSEL_gm | PORTCFG_CLKOUT_gm);
	LDS  R30,180
	ANDI R30,LOW(0xF0)
	STS  180,R30
; 0000 003F // Restore interrupts enabled/disabled state
; 0000 0040 SREG=s;
	OUT  0x3F,R16
; 0000 0041 // Restore optimization for size if needed
; 0000 0042 #pragma optsize_default
; 0000 0043 }
	RJMP _0x2060004
; .FEND
;
;// Event System initialization
;void event_system_init(void)
; 0000 0047 {
_event_system_init:
; .FSTART _event_system_init
; 0000 0048 // Event System Channel 0 source: None
; 0000 0049 EVSYS.CH0MUX=EVSYS_CHMUX_OFF_gc;
	LDI  R30,LOW(0)
	STS  384,R30
; 0000 004A // Event System Channel 1 source: None
; 0000 004B EVSYS.CH1MUX=EVSYS_CHMUX_OFF_gc;
	STS  385,R30
; 0000 004C // Event System Channel 2 source: None
; 0000 004D EVSYS.CH2MUX=EVSYS_CHMUX_OFF_gc;
	STS  386,R30
; 0000 004E // Event System Channel 3 source: None
; 0000 004F EVSYS.CH3MUX=EVSYS_CHMUX_OFF_gc;
	STS  387,R30
; 0000 0050 // Event System Channel 4 source: None
; 0000 0051 EVSYS.CH4MUX=EVSYS_CHMUX_OFF_gc;
	STS  388,R30
; 0000 0052 // Event System Channel 5 source: None
; 0000 0053 EVSYS.CH5MUX=EVSYS_CHMUX_OFF_gc;
	STS  389,R30
; 0000 0054 // Event System Channel 6 source: None
; 0000 0055 EVSYS.CH6MUX=EVSYS_CHMUX_OFF_gc;
	STS  390,R30
; 0000 0056 // Event System Channel 7 source: None
; 0000 0057 EVSYS.CH7MUX=EVSYS_CHMUX_OFF_gc;
	STS  391,R30
; 0000 0058 
; 0000 0059 // Event System Channel 0 Digital Filter Coefficient: 1 Sample
; 0000 005A // Quadrature Decoder: Off
; 0000 005B EVSYS.CH0CTRL=(EVSYS.CH0CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
; 0000 005C 	EVSYS_DIGFILT_1SAMPLE_gc;
	LDS  R30,392
	ANDI R30,LOW(0x80)
	STS  392,R30
; 0000 005D // Event System Channel 1 Digital Filter Coefficient: 1 Sample
; 0000 005E EVSYS.CH1CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	LDI  R30,LOW(0)
	STS  393,R30
; 0000 005F // Event System Channel 2 Digital Filter Coefficient: 1 Sample
; 0000 0060 // Quadrature Decoder: Off
; 0000 0061 EVSYS.CH2CTRL=(EVSYS.CH2CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
; 0000 0062 	EVSYS_DIGFILT_1SAMPLE_gc;
	LDS  R30,394
	ANDI R30,LOW(0x80)
	STS  394,R30
; 0000 0063 // Event System Channel 3 Digital Filter Coefficient: 1 Sample
; 0000 0064 EVSYS.CH3CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	LDI  R30,LOW(0)
	STS  395,R30
; 0000 0065 // Event System Channel 4 Digital Filter Coefficient: 1 Sample
; 0000 0066 // Quadrature Decoder: Off
; 0000 0067 EVSYS.CH4CTRL=(EVSYS.CH4CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
; 0000 0068 	EVSYS_DIGFILT_1SAMPLE_gc;
	LDS  R30,396
	ANDI R30,LOW(0x80)
	STS  396,R30
; 0000 0069 // Event System Channel 5 Digital Filter Coefficient: 1 Sample
; 0000 006A EVSYS.CH5CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	LDI  R30,LOW(0)
	STS  397,R30
; 0000 006B // Event System Channel 6 Digital Filter Coefficient: 1 Sample
; 0000 006C EVSYS.CH6CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	STS  398,R30
; 0000 006D // Event System Channel 7 Digital Filter Coefficient: 1 Sample
; 0000 006E EVSYS.CH7CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	STS  399,R30
; 0000 006F 
; 0000 0070 // Event System Channel output: Disabled
; 0000 0071 PORTCFG.CLKEVOUT&= ~PORTCFG_EVOUT_gm;
	LDS  R30,180
	ANDI R30,LOW(0xCF)
	STS  180,R30
; 0000 0072 PORTCFG.EVOUTSEL&= ~PORTCFG_EVOUTSEL_gm;
	LDS  R30,182
	ANDI R30,LOW(0xF8)
	STS  182,R30
; 0000 0073 }
	RET
; .FEND
;
;// Ports initialization
;void ports_init(void)
; 0000 0077 {
_ports_init:
; .FSTART _ports_init
; 0000 0078 // PORTA initialization
; 0000 0079 // OUT register
; 0000 007A PORTA.OUT=0x00;
	LDI  R30,LOW(0)
	STS  1540,R30
; 0000 007B // Pin0: Input
; 0000 007C // Pin1: Input
; 0000 007D // Pin2: Input
; 0000 007E // Pin3: Input
; 0000 007F // Pin4: Input
; 0000 0080 // Pin5: Input
; 0000 0081 // Pin6: Input
; 0000 0082 // Pin7: Input
; 0000 0083 PORTA.DIR=0x00;
	STS  1536,R30
; 0000 0084 // Pin0 Output/Pull configuration: Totempole/No
; 0000 0085 // Pin0 Input/Sense configuration: Sense both edges
; 0000 0086 // Pin0 Inverted: Off
; 0000 0087 // Pin0 Slew Rate Limitation: Off
; 0000 0088 PORTA.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1552,R30
; 0000 0089 // Pin1 Output/Pull configuration: Totempole/No
; 0000 008A // Pin1 Input/Sense configuration: Sense both edges
; 0000 008B // Pin1 Inverted: Off
; 0000 008C // Pin1 Slew Rate Limitation: Off
; 0000 008D PORTA.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1553,R30
; 0000 008E // Pin2 Output/Pull configuration: Totempole/No
; 0000 008F // Pin2 Input/Sense configuration: Sense both edges
; 0000 0090 // Pin2 Inverted: Off
; 0000 0091 // Pin2 Slew Rate Limitation: Off
; 0000 0092 PORTA.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1554,R30
; 0000 0093 // Pin3 Output/Pull configuration: Totempole/No
; 0000 0094 // Pin3 Input/Sense configuration: Sense both edges
; 0000 0095 // Pin3 Inverted: Off
; 0000 0096 // Pin3 Slew Rate Limitation: Off
; 0000 0097 PORTA.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1555,R30
; 0000 0098 // Pin4 Output/Pull configuration: Totempole/No
; 0000 0099 // Pin4 Input/Sense configuration: Sense both edges
; 0000 009A // Pin4 Inverted: Off
; 0000 009B // Pin4 Slew Rate Limitation: Off
; 0000 009C PORTA.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1556,R30
; 0000 009D // Pin5 Output/Pull configuration: Totempole/No
; 0000 009E // Pin5 Input/Sense configuration: Sense both edges
; 0000 009F // Pin5 Inverted: Off
; 0000 00A0 // Pin5 Slew Rate Limitation: Off
; 0000 00A1 PORTA.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1557,R30
; 0000 00A2 // Pin6 Output/Pull configuration: Totempole/No
; 0000 00A3 // Pin6 Input/Sense configuration: Sense both edges
; 0000 00A4 // Pin6 Inverted: Off
; 0000 00A5 // Pin6 Slew Rate Limitation: Off
; 0000 00A6 PORTA.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1558,R30
; 0000 00A7 // Pin7 Output/Pull configuration: Totempole/No
; 0000 00A8 // Pin7 Input/Sense configuration: Sense both edges
; 0000 00A9 // Pin7 Inverted: Off
; 0000 00AA // Pin7 Slew Rate Limitation: Off
; 0000 00AB PORTA.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1559,R30
; 0000 00AC // Interrupt 0 level: Disabled
; 0000 00AD // Interrupt 1 level: Disabled
; 0000 00AE PORTA.INTCTRL=(PORTA.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 00AF     PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1545
	ANDI R30,LOW(0xF0)
	STS  1545,R30
; 0000 00B0 // Pin0 Pin Change interrupt 0: Off
; 0000 00B1 // Pin1 Pin Change interrupt 0: Off
; 0000 00B2 // Pin2 Pin Change interrupt 0: Off
; 0000 00B3 // Pin3 Pin Change interrupt 0: Off
; 0000 00B4 // Pin4 Pin Change interrupt 0: Off
; 0000 00B5 // Pin5 Pin Change interrupt 0: Off
; 0000 00B6 // Pin6 Pin Change interrupt 0: Off
; 0000 00B7 // Pin7 Pin Change interrupt 0: Off
; 0000 00B8 PORTA.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1546,R30
; 0000 00B9 // Pin0 Pin Change interrupt 1: Off
; 0000 00BA // Pin1 Pin Change interrupt 1: Off
; 0000 00BB // Pin2 Pin Change interrupt 1: Off
; 0000 00BC // Pin3 Pin Change interrupt 1: Off
; 0000 00BD // Pin4 Pin Change interrupt 1: Off
; 0000 00BE // Pin5 Pin Change interrupt 1: Off
; 0000 00BF // Pin6 Pin Change interrupt 1: Off
; 0000 00C0 // Pin7 Pin Change interrupt 1: Off
; 0000 00C1 PORTA.INT1MASK=0x00;
	STS  1547,R30
; 0000 00C2 
; 0000 00C3 // PORTB initialization
; 0000 00C4 // OUT register
; 0000 00C5 PORTB.OUT=0x00;
	STS  1572,R30
; 0000 00C6 // Pin0: Input
; 0000 00C7 // Pin1: Input
; 0000 00C8 // Pin2: Input
; 0000 00C9 // Pin3: Input
; 0000 00CA // Pin4: Input
; 0000 00CB // Pin5: Input
; 0000 00CC // Pin6: Input
; 0000 00CD // Pin7: Input
; 0000 00CE PORTB.DIR=0x00;
	STS  1568,R30
; 0000 00CF // Pin0 Output/Pull configuration: Totempole/No
; 0000 00D0 // Pin0 Input/Sense configuration: Sense both edges
; 0000 00D1 // Pin0 Inverted: Off
; 0000 00D2 // Pin0 Slew Rate Limitation: Off
; 0000 00D3 PORTB.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1584,R30
; 0000 00D4 // Pin1 Output/Pull configuration: Totempole/No
; 0000 00D5 // Pin1 Input/Sense configuration: Sense both edges
; 0000 00D6 // Pin1 Inverted: Off
; 0000 00D7 // Pin1 Slew Rate Limitation: Off
; 0000 00D8 PORTB.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1585,R30
; 0000 00D9 // Pin2 Output/Pull configuration: Totempole/No
; 0000 00DA // Pin2 Input/Sense configuration: Sense both edges
; 0000 00DB // Pin2 Inverted: Off
; 0000 00DC // Pin2 Slew Rate Limitation: Off
; 0000 00DD PORTB.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1586,R30
; 0000 00DE // Pin3 Output/Pull configuration: Totempole/No
; 0000 00DF // Pin3 Input/Sense configuration: Sense both edges
; 0000 00E0 // Pin3 Inverted: Off
; 0000 00E1 // Pin3 Slew Rate Limitation: Off
; 0000 00E2 PORTB.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1587,R30
; 0000 00E3 // Pin4 Output/Pull configuration: Totempole/No
; 0000 00E4 // Pin4 Input/Sense configuration: Sense both edges
; 0000 00E5 // Pin4 Inverted: Off
; 0000 00E6 // Pin4 Slew Rate Limitation: Off
; 0000 00E7 PORTB.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1588,R30
; 0000 00E8 // Pin5 Output/Pull configuration: Totempole/No
; 0000 00E9 // Pin5 Input/Sense configuration: Sense both edges
; 0000 00EA // Pin5 Inverted: Off
; 0000 00EB // Pin5 Slew Rate Limitation: Off
; 0000 00EC PORTB.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1589,R30
; 0000 00ED // Pin6 Output/Pull configuration: Totempole/No
; 0000 00EE // Pin6 Input/Sense configuration: Sense both edges
; 0000 00EF // Pin6 Inverted: Off
; 0000 00F0 // Pin6 Slew Rate Limitation: Off
; 0000 00F1 PORTB.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1590,R30
; 0000 00F2 // Pin7 Output/Pull configuration: Totempole/No
; 0000 00F3 // Pin7 Input/Sense configuration: Sense both edges
; 0000 00F4 // Pin7 Inverted: Off
; 0000 00F5 // Pin7 Slew Rate Limitation: Off
; 0000 00F6 PORTB.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1591,R30
; 0000 00F7 // Interrupt 0 level: Disabled
; 0000 00F8 // Interrupt 1 level: Disabled
; 0000 00F9 PORTB.INTCTRL=(PORTB.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 00FA     PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1577
	ANDI R30,LOW(0xF0)
	STS  1577,R30
; 0000 00FB // Pin0 Pin Change interrupt 0: Off
; 0000 00FC // Pin1 Pin Change interrupt 0: Off
; 0000 00FD // Pin2 Pin Change interrupt 0: Off
; 0000 00FE // Pin3 Pin Change interrupt 0: Off
; 0000 00FF // Pin4 Pin Change interrupt 0: Off
; 0000 0100 // Pin5 Pin Change interrupt 0: Off
; 0000 0101 // Pin6 Pin Change interrupt 0: Off
; 0000 0102 // Pin7 Pin Change interrupt 0: Off
; 0000 0103 PORTB.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1578,R30
; 0000 0104 // Pin0 Pin Change interrupt 1: Off
; 0000 0105 // Pin1 Pin Change interrupt 1: Off
; 0000 0106 // Pin2 Pin Change interrupt 1: Off
; 0000 0107 // Pin3 Pin Change interrupt 1: Off
; 0000 0108 // Pin4 Pin Change interrupt 1: Off
; 0000 0109 // Pin5 Pin Change interrupt 1: Off
; 0000 010A // Pin6 Pin Change interrupt 1: Off
; 0000 010B // Pin7 Pin Change interrupt 1: Off
; 0000 010C PORTB.INT1MASK=0x00;
	STS  1579,R30
; 0000 010D 
; 0000 010E // PORTC initialization
; 0000 010F // OUT register
; 0000 0110 PORTC.OUT=0x04;
	LDI  R30,LOW(4)
	STS  1604,R30
; 0000 0111 // Pin0: Output
; 0000 0112 // Pin1: Output
; 0000 0113 // Pin2: Output
; 0000 0114 // Pin3: Input
; 0000 0115 // Pin4: Input
; 0000 0116 // Pin5: Input
; 0000 0117 // Pin6: Input
; 0000 0118 // Pin7: Input
; 0000 0119 PORTC.DIR=0x07;
	LDI  R30,LOW(7)
	STS  1600,R30
; 0000 011A // Pin0 Output/Pull configuration: Totempole/No
; 0000 011B // Pin0 Input/Sense configuration: Sense both edges
; 0000 011C // Pin0 Inverted: Off
; 0000 011D // Pin0 Slew Rate Limitation: Off
; 0000 011E PORTC.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1616,R30
; 0000 011F // Pin1 Output/Pull configuration: Totempole/No
; 0000 0120 // Pin1 Input/Sense configuration: Sense both edges
; 0000 0121 // Pin1 Inverted: Off
; 0000 0122 // Pin1 Slew Rate Limitation: Off
; 0000 0123 PORTC.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1617,R30
; 0000 0124 // Pin2 Output/Pull configuration: Totempole/No
; 0000 0125 // Pin2 Input/Sense configuration: Sense both edges
; 0000 0126 // Pin2 Inverted: Off
; 0000 0127 // Pin2 Slew Rate Limitation: Off
; 0000 0128 PORTC.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1618,R30
; 0000 0129 // Pin3 Output/Pull configuration: Totempole/No
; 0000 012A // Pin3 Input/Sense configuration: Sense both edges
; 0000 012B // Pin3 Inverted: Off
; 0000 012C // Pin3 Slew Rate Limitation: Off
; 0000 012D PORTC.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1619,R30
; 0000 012E // Pin4 Output/Pull configuration: Totempole/No
; 0000 012F // Pin4 Input/Sense configuration: Sense both edges
; 0000 0130 // Pin4 Inverted: Off
; 0000 0131 // Pin4 Slew Rate Limitation: Off
; 0000 0132 PORTC.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1620,R30
; 0000 0133 // Pin5 Output/Pull configuration: Totempole/No
; 0000 0134 // Pin5 Input/Sense configuration: Sense both edges
; 0000 0135 // Pin5 Inverted: Off
; 0000 0136 // Pin5 Slew Rate Limitation: Off
; 0000 0137 PORTC.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1621,R30
; 0000 0138 // Pin6 Output/Pull configuration: Totempole/No
; 0000 0139 // Pin6 Input/Sense configuration: Sense both edges
; 0000 013A // Pin6 Inverted: Off
; 0000 013B // Pin6 Slew Rate Limitation: Off
; 0000 013C PORTC.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1622,R30
; 0000 013D // Pin7 Output/Pull configuration: Totempole/No
; 0000 013E // Pin7 Input/Sense configuration: Sense both edges
; 0000 013F // Pin7 Inverted: Off
; 0000 0140 // Pin7 Slew Rate Limitation: Off
; 0000 0141 PORTC.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1623,R30
; 0000 0142 // PORTC Peripheral Output Remapping
; 0000 0143 // OC0A Output: Pin 0
; 0000 0144 // OC0B Output: Pin 1
; 0000 0145 // OC0C Output: Pin 2
; 0000 0146 // OC0D Output: Pin 3
; 0000 0147 // USART0 XCK: Pin 1
; 0000 0148 // USART0 RXD: Pin 2
; 0000 0149 // USART0 TXD: Pin 3
; 0000 014A // SPI MOSI: Pin 5
; 0000 014B // SPI SCK: Pin 7
; 0000 014C PORTC.REMAP=(0<<PORT_SPI_bp) | (0<<PORT_USART0_bp) | (0<<PORT_TC0D_bp) | (0<<PORT_TC0C_bp) | (0<<PORT_TC0B_bp) | (0<<POR ...
	STS  1614,R30
; 0000 014D // Interrupt 0 level: Disabled
; 0000 014E // Interrupt 1 level: Disabled
; 0000 014F PORTC.INTCTRL=(PORTC.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 0150     PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1609
	ANDI R30,LOW(0xF0)
	STS  1609,R30
; 0000 0151 // Pin0 Pin Change interrupt 0: Off
; 0000 0152 // Pin1 Pin Change interrupt 0: Off
; 0000 0153 // Pin2 Pin Change interrupt 0: Off
; 0000 0154 // Pin3 Pin Change interrupt 0: Off
; 0000 0155 // Pin4 Pin Change interrupt 0: Off
; 0000 0156 // Pin5 Pin Change interrupt 0: Off
; 0000 0157 // Pin6 Pin Change interrupt 0: Off
; 0000 0158 // Pin7 Pin Change interrupt 0: Off
; 0000 0159 PORTC.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1610,R30
; 0000 015A // Pin0 Pin Change interrupt 1: Off
; 0000 015B // Pin1 Pin Change interrupt 1: Off
; 0000 015C // Pin2 Pin Change interrupt 1: Off
; 0000 015D // Pin3 Pin Change interrupt 1: Off
; 0000 015E // Pin4 Pin Change interrupt 1: Off
; 0000 015F // Pin5 Pin Change interrupt 1: Off
; 0000 0160 // Pin6 Pin Change interrupt 1: Off
; 0000 0161 // Pin7 Pin Change interrupt 1: Off
; 0000 0162 PORTC.INT1MASK=0x00;
	STS  1611,R30
; 0000 0163 
; 0000 0164 // PORTD initialization
; 0000 0165 // OUT register
; 0000 0166 PORTD.OUT=0x00;
	STS  1636,R30
; 0000 0167 // Pin0: Input
; 0000 0168 // Pin1: Input
; 0000 0169 // Pin2: Input
; 0000 016A // Pin3: Input
; 0000 016B // Pin4: Output
; 0000 016C // Pin5: Output
; 0000 016D // Pin6: Output
; 0000 016E // Pin7: Output
; 0000 016F PORTD.DIR=0xF0;
	LDI  R30,LOW(240)
	STS  1632,R30
; 0000 0170 // Pin0 Output/Pull configuration: Totempole/No
; 0000 0171 // Pin0 Input/Sense configuration: Sense both edges
; 0000 0172 // Pin0 Inverted: Off
; 0000 0173 // Pin0 Slew Rate Limitation: Off
; 0000 0174 PORTD.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1648,R30
; 0000 0175 // Pin1 Output/Pull configuration: Totempole/No
; 0000 0176 // Pin1 Input/Sense configuration: Sense both edges
; 0000 0177 // Pin1 Inverted: Off
; 0000 0178 // Pin1 Slew Rate Limitation: Off
; 0000 0179 PORTD.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1649,R30
; 0000 017A // Pin2 Output/Pull configuration: Totempole/No
; 0000 017B // Pin2 Input/Sense configuration: Sense both edges
; 0000 017C // Pin2 Inverted: Off
; 0000 017D // Pin2 Slew Rate Limitation: Off
; 0000 017E PORTD.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1650,R30
; 0000 017F // Pin3 Output/Pull configuration: Totempole/No
; 0000 0180 // Pin3 Input/Sense configuration: Sense both edges
; 0000 0181 // Pin3 Inverted: Off
; 0000 0182 // Pin3 Slew Rate Limitation: Off
; 0000 0183 PORTD.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1651,R30
; 0000 0184 // Pin4 Output/Pull configuration: Totempole/No
; 0000 0185 // Pin4 Input/Sense configuration: Sense both edges
; 0000 0186 // Pin4 Inverted: Off
; 0000 0187 // Pin4 Slew Rate Limitation: Off
; 0000 0188 PORTD.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1652,R30
; 0000 0189 // Pin5 Output/Pull configuration: Totempole/No
; 0000 018A // Pin5 Input/Sense configuration: Sense both edges
; 0000 018B // Pin5 Inverted: Off
; 0000 018C // Pin5 Slew Rate Limitation: Off
; 0000 018D PORTD.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1653,R30
; 0000 018E // Pin6 Output/Pull configuration: Totempole/No
; 0000 018F // Pin6 Input/Sense configuration: Sense both edges
; 0000 0190 // Pin6 Inverted: Off
; 0000 0191 // Pin6 Slew Rate Limitation: Off
; 0000 0192 PORTD.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1654,R30
; 0000 0193 // Pin7 Output/Pull configuration: Totempole/No
; 0000 0194 // Pin7 Input/Sense configuration: Sense both edges
; 0000 0195 // Pin7 Inverted: Off
; 0000 0196 // Pin7 Slew Rate Limitation: Off
; 0000 0197 PORTD.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1655,R30
; 0000 0198 // Interrupt 0 level: Disabled
; 0000 0199 // Interrupt 1 level: Disabled
; 0000 019A PORTD.INTCTRL=(PORTD.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 019B     PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1641
	ANDI R30,LOW(0xF0)
	STS  1641,R30
; 0000 019C // Pin0 Pin Change interrupt 0: Off
; 0000 019D // Pin1 Pin Change interrupt 0: Off
; 0000 019E // Pin2 Pin Change interrupt 0: Off
; 0000 019F // Pin3 Pin Change interrupt 0: Off
; 0000 01A0 // Pin4 Pin Change interrupt 0: Off
; 0000 01A1 // Pin5 Pin Change interrupt 0: Off
; 0000 01A2 // Pin6 Pin Change interrupt 0: Off
; 0000 01A3 // Pin7 Pin Change interrupt 0: Off
; 0000 01A4 PORTD.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1642,R30
; 0000 01A5 // Pin0 Pin Change interrupt 1: Off
; 0000 01A6 // Pin1 Pin Change interrupt 1: Off
; 0000 01A7 // Pin2 Pin Change interrupt 1: Off
; 0000 01A8 // Pin3 Pin Change interrupt 1: Off
; 0000 01A9 // Pin4 Pin Change interrupt 1: Off
; 0000 01AA // Pin5 Pin Change interrupt 1: Off
; 0000 01AB // Pin6 Pin Change interrupt 1: Off
; 0000 01AC // Pin7 Pin Change interrupt 1: Off
; 0000 01AD PORTD.INT1MASK=0x00;
	STS  1643,R30
; 0000 01AE 
; 0000 01AF // PORTE initialization
; 0000 01B0 // OUT register
; 0000 01B1 PORTE.OUT=0x00;
	STS  1668,R30
; 0000 01B2 // Pin0: Output
; 0000 01B3 // Pin1: Output
; 0000 01B4 // Pin2: Output
; 0000 01B5 // Pin3: Output
; 0000 01B6 // Pin4: Output
; 0000 01B7 // Pin5: Output
; 0000 01B8 // Pin6: Output
; 0000 01B9 // Pin7: Output
; 0000 01BA PORTE.DIR=0xFF;
	LDI  R30,LOW(255)
	STS  1664,R30
; 0000 01BB // Pin0 Output/Pull configuration: Totempole/No
; 0000 01BC // Pin0 Input/Sense configuration: Sense both edges
; 0000 01BD // Pin0 Inverted: Off
; 0000 01BE // Pin0 Slew Rate Limitation: Off
; 0000 01BF PORTE.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1680,R30
; 0000 01C0 // Pin1 Output/Pull configuration: Totempole/No
; 0000 01C1 // Pin1 Input/Sense configuration: Sense both edges
; 0000 01C2 // Pin1 Inverted: Off
; 0000 01C3 // Pin1 Slew Rate Limitation: Off
; 0000 01C4 PORTE.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1681,R30
; 0000 01C5 // Pin2 Output/Pull configuration: Totempole/No
; 0000 01C6 // Pin2 Input/Sense configuration: Sense both edges
; 0000 01C7 // Pin2 Inverted: Off
; 0000 01C8 // Pin2 Slew Rate Limitation: Off
; 0000 01C9 PORTE.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1682,R30
; 0000 01CA // Pin3 Output/Pull configuration: Totempole/No
; 0000 01CB // Pin3 Input/Sense configuration: Sense both edges
; 0000 01CC // Pin3 Inverted: Off
; 0000 01CD // Pin3 Slew Rate Limitation: Off
; 0000 01CE PORTE.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1683,R30
; 0000 01CF // Pin4 Output/Pull configuration: Totempole/No
; 0000 01D0 // Pin4 Input/Sense configuration: Sense both edges
; 0000 01D1 // Pin4 Inverted: Off
; 0000 01D2 // Pin4 Slew Rate Limitation: Off
; 0000 01D3 PORTE.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1684,R30
; 0000 01D4 // Pin5 Output/Pull configuration: Totempole/No
; 0000 01D5 // Pin5 Input/Sense configuration: Sense both edges
; 0000 01D6 // Pin5 Inverted: Off
; 0000 01D7 // Pin5 Slew Rate Limitation: Off
; 0000 01D8 PORTE.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1685,R30
; 0000 01D9 // Pin6 Output/Pull configuration: Totempole/No
; 0000 01DA // Pin6 Input/Sense configuration: Sense both edges
; 0000 01DB // Pin6 Inverted: Off
; 0000 01DC // Pin6 Slew Rate Limitation: Off
; 0000 01DD PORTE.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1686,R30
; 0000 01DE // Pin7 Output/Pull configuration: Totempole/No
; 0000 01DF // Pin7 Input/Sense configuration: Sense both edges
; 0000 01E0 // Pin7 Inverted: Off
; 0000 01E1 // Pin7 Slew Rate Limitation: Off
; 0000 01E2 PORTE.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1687,R30
; 0000 01E3 // Interrupt 0 level: Disabled
; 0000 01E4 // Interrupt 1 level: Disabled
; 0000 01E5 PORTE.INTCTRL=(PORTE.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 01E6     PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1673
	ANDI R30,LOW(0xF0)
	STS  1673,R30
; 0000 01E7 // Pin0 Pin Change interrupt 0: Off
; 0000 01E8 // Pin1 Pin Change interrupt 0: Off
; 0000 01E9 // Pin2 Pin Change interrupt 0: Off
; 0000 01EA // Pin3 Pin Change interrupt 0: Off
; 0000 01EB // Pin4 Pin Change interrupt 0: Off
; 0000 01EC // Pin5 Pin Change interrupt 0: Off
; 0000 01ED // Pin6 Pin Change interrupt 0: Off
; 0000 01EE // Pin7 Pin Change interrupt 0: Off
; 0000 01EF PORTE.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1674,R30
; 0000 01F0 // Pin0 Pin Change interrupt 1: Off
; 0000 01F1 // Pin1 Pin Change interrupt 1: Off
; 0000 01F2 // Pin2 Pin Change interrupt 1: Off
; 0000 01F3 // Pin3 Pin Change interrupt 1: Off
; 0000 01F4 // Pin4 Pin Change interrupt 1: Off
; 0000 01F5 // Pin5 Pin Change interrupt 1: Off
; 0000 01F6 // Pin6 Pin Change interrupt 1: Off
; 0000 01F7 // Pin7 Pin Change interrupt 1: Off
; 0000 01F8 PORTE.INT1MASK=0x00;
	STS  1675,R30
; 0000 01F9 
; 0000 01FA // PORTF initialization
; 0000 01FB // OUT register
; 0000 01FC PORTF.OUT=0x00;
	STS  1700,R30
; 0000 01FD // Pin0: Input
; 0000 01FE // Pin1: Input
; 0000 01FF // Pin2: Input
; 0000 0200 // Pin3: Output
; 0000 0201 // Pin4: Input
; 0000 0202 // Pin5: Input
; 0000 0203 // Pin6: Input
; 0000 0204 // Pin7: Input
; 0000 0205 PORTF.DIR=0x08;
	LDI  R30,LOW(8)
	STS  1696,R30
; 0000 0206 // Pin0 Output/Pull configuration: Totempole/No
; 0000 0207 // Pin0 Input/Sense configuration: Sense both edges
; 0000 0208 // Pin0 Inverted: Off
; 0000 0209 // Pin0 Slew Rate Limitation: Off
; 0000 020A PORTF.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1712,R30
; 0000 020B // Pin1 Output/Pull configuration: Totempole/No
; 0000 020C // Pin1 Input/Sense configuration: Sense both edges
; 0000 020D // Pin1 Inverted: Off
; 0000 020E // Pin1 Slew Rate Limitation: Off
; 0000 020F PORTF.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1713,R30
; 0000 0210 // Pin2 Output/Pull configuration: Totempole/No
; 0000 0211 // Pin2 Input/Sense configuration: Sense both edges
; 0000 0212 // Pin2 Inverted: Off
; 0000 0213 // Pin2 Slew Rate Limitation: Off
; 0000 0214 PORTF.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1714,R30
; 0000 0215 // Pin3 Output/Pull configuration: Totempole/No
; 0000 0216 // Pin3 Input/Sense configuration: Sense both edges
; 0000 0217 // Pin3 Inverted: Off
; 0000 0218 // Pin3 Slew Rate Limitation: Off
; 0000 0219 PORTF.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1715,R30
; 0000 021A // Pin4 Output/Pull configuration: Totempole/No
; 0000 021B // Pin4 Input/Sense configuration: Sense both edges
; 0000 021C // Pin4 Inverted: Off
; 0000 021D // Pin4 Slew Rate Limitation: Off
; 0000 021E PORTF.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1716,R30
; 0000 021F // Pin5 Output/Pull configuration: Totempole/No
; 0000 0220 // Pin5 Input/Sense configuration: Sense both edges
; 0000 0221 // Pin5 Inverted: Off
; 0000 0222 // Pin5 Slew Rate Limitation: Off
; 0000 0223 PORTF.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1717,R30
; 0000 0224 // Pin6 Output/Pull configuration: Totempole/No
; 0000 0225 // Pin6 Input/Sense configuration: Sense both edges
; 0000 0226 // Pin6 Inverted: Off
; 0000 0227 // Pin6 Slew Rate Limitation: Off
; 0000 0228 PORTF.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1718,R30
; 0000 0229 // Pin7 Output/Pull configuration: Totempole/No
; 0000 022A // Pin7 Input/Sense configuration: Sense both edges
; 0000 022B // Pin7 Inverted: Off
; 0000 022C // Pin7 Slew Rate Limitation: Off
; 0000 022D PORTF.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1719,R30
; 0000 022E // Interrupt 0 level: Disabled
; 0000 022F // Interrupt 1 level: Disabled
; 0000 0230 PORTF.INTCTRL=(PORTF.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 0231 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1705
	ANDI R30,LOW(0xF0)
	STS  1705,R30
; 0000 0232 // Pin0 Pin Change interrupt 0: Off
; 0000 0233 // Pin1 Pin Change interrupt 0: Off
; 0000 0234 // Pin2 Pin Change interrupt 0: Off
; 0000 0235 // Pin3 Pin Change interrupt 0: Off
; 0000 0236 // Pin4 Pin Change interrupt 0: Off
; 0000 0237 // Pin5 Pin Change interrupt 0: Off
; 0000 0238 // Pin6 Pin Change interrupt 0: Off
; 0000 0239 // Pin7 Pin Change interrupt 0: Off
; 0000 023A PORTF.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1706,R30
; 0000 023B // Pin0 Pin Change interrupt 1: Off
; 0000 023C // Pin1 Pin Change interrupt 1: Off
; 0000 023D // Pin2 Pin Change interrupt 1: Off
; 0000 023E // Pin3 Pin Change interrupt 1: Off
; 0000 023F // Pin4 Pin Change interrupt 1: Off
; 0000 0240 // Pin5 Pin Change interrupt 1: Off
; 0000 0241 // Pin6 Pin Change interrupt 1: Off
; 0000 0242 // Pin7 Pin Change interrupt 1: Off
; 0000 0243 PORTF.INT1MASK=0x00;
	STS  1707,R30
; 0000 0244 
; 0000 0245 // PORTR initialization
; 0000 0246 // OUT register
; 0000 0247 PORTR.OUT=0x00;
	STS  2020,R30
; 0000 0248 // Pin0: Input
; 0000 0249 // Pin1: Input
; 0000 024A PORTR.DIR=0x00;
	STS  2016,R30
; 0000 024B // Pin0 Output/Pull configuration: Totempole/No
; 0000 024C // Pin0 Input/Sense configuration: Sense both edges
; 0000 024D // Pin0 Inverted: Off
; 0000 024E // Pin0 Slew Rate Limitation: Off
; 0000 024F PORTR.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  2032,R30
; 0000 0250 // Pin1 Output/Pull configuration: Totempole/No
; 0000 0251 // Pin1 Input/Sense configuration: Sense both edges
; 0000 0252 // Pin1 Inverted: Off
; 0000 0253 // Pin1 Slew Rate Limitation: Off
; 0000 0254 PORTR.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  2033,R30
; 0000 0255 // Interrupt 0 level: Disabled
; 0000 0256 // Interrupt 1 level: Disabled
; 0000 0257 PORTR.INTCTRL=(PORTR.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 0258 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,2025
	ANDI R30,LOW(0xF0)
	STS  2025,R30
; 0000 0259 // Pin0 Pin Change interrupt 0: Off
; 0000 025A // Pin1 Pin Change interrupt 0: Off
; 0000 025B PORTR.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  2026,R30
; 0000 025C // Pin0 Pin Change interrupt 1: Off
; 0000 025D // Pin1 Pin Change interrupt 1: Off
; 0000 025E PORTR.INT1MASK=0x00;
	STS  2027,R30
; 0000 025F }
	RET
; .FEND
;
;// Virtual Ports initialization
;void vports_init(void)
; 0000 0263 {
_vports_init:
; .FSTART _vports_init
; 0000 0264 // PORTA mapped to VPORT0
; 0000 0265 // PORTB mapped to VPORT1
; 0000 0266 PORTCFG.VPCTRLA=PORTCFG_VP13MAP_PORTB_gc | PORTCFG_VP02MAP_PORTA_gc;
	LDI  R30,LOW(16)
	STS  178,R30
; 0000 0267 // PORTC mapped to VPORT2
; 0000 0268 // PORTD mapped to VPORT3
; 0000 0269 PORTCFG.VPCTRLB=PORTCFG_VP13MAP_PORTD_gc | PORTCFG_VP02MAP_PORTC_gc;
	LDI  R30,LOW(50)
	STS  179,R30
; 0000 026A }
	RET
; .FEND
;
;// USARTF0 initialization
;void usartf0_init(void)
; 0000 026E {
_usartf0_init:
; .FSTART _usartf0_init
; 0000 026F // Note: The correct PORTF direction for the RxD, TxD and XCK signals
; 0000 0270 // is configured in the ports_init function.
; 0000 0271 
; 0000 0272 // Transmitter is enabled
; 0000 0273 // Set TxD=1
; 0000 0274 PORTF.OUTSET=0x08;
	LDI  R30,LOW(8)
	STS  1701,R30
; 0000 0275 
; 0000 0276 // Communication mode: Asynchronous USART
; 0000 0277 // Data bits: 8
; 0000 0278 // Stop bits: 1
; 0000 0279 // Parity: Disabled
; 0000 027A USARTF0.CTRLC=USART_CMODE_ASYNCHRONOUS_gc | USART_PMODE_DISABLED_gc | USART_CHSIZE_8BIT_gc;
	LDI  R30,LOW(3)
	STS  2981,R30
; 0000 027B 
; 0000 027C // Receive complete interrupt: High Level
; 0000 027D // Transmit complete interrupt: Medium Level
; 0000 027E // Data register empty interrupt: Disabled
; 0000 027F USARTF0.CTRLA=(USARTF0.CTRLA & (~(USART_RXCINTLVL_gm | USART_TXCINTLVL_gm | USART_DREINTLVL_gm))) |
; 0000 0280 	USART_RXCINTLVL_HI_gc | USART_TXCINTLVL_MED_gc | USART_DREINTLVL_OFF_gc;
	LDS  R30,2979
	ANDI R30,LOW(0xC0)
	ORI  R30,LOW(0x38)
	STS  2979,R30
; 0000 0281 
; 0000 0282 // Required Baud rate: 115200
; 0000 0283 // Real Baud Rate: 115211.5 (x1 Mode), Error: 0.0 %
; 0000 0284 USARTF0.BAUDCTRLA=0x2E;
	LDI  R30,LOW(46)
	STS  2982,R30
; 0000 0285 USARTF0.BAUDCTRLB=((0x09 << USART_BSCALE_gp) & USART_BSCALE_gm) | 0x08;
	LDI  R30,LOW(152)
	STS  2983,R30
; 0000 0286 
; 0000 0287 // Receiver: On
; 0000 0288 // Transmitter: On
; 0000 0289 // Double transmission speed mode: Off
; 0000 028A // Multi-processor communication mode: Off
; 0000 028B USARTF0.CTRLB=(USARTF0.CTRLB & (~(USART_RXEN_bm | USART_TXEN_bm | USART_CLK2X_bm | USART_MPCM_bm | USART_TXB8_bm))) |
; 0000 028C 	USART_RXEN_bm | USART_TXEN_bm;
	LDS  R30,2980
	ANDI R30,LOW(0xE0)
	ORI  R30,LOW(0x18)
	STS  2980,R30
; 0000 028D }
	RET
; .FEND
;
;// USARTF0 Receiver buffer
;#define RX_BUFFER_SIZE_USARTF0 64
;char rx_buffer_usartf0[RX_BUFFER_SIZE_USARTF0];
;
;#if RX_BUFFER_SIZE_USARTF0 <= 256
;unsigned char rx_wr_index_usartf0=0,rx_rd_index_usartf0=0;
;#else
;unsigned int rx_wr_index_usartf0=0,rx_rd_index_usartf0=0;
;#endif
;
;#if RX_BUFFER_SIZE_USARTF0 < 256
;unsigned char rx_counter_usartf0=0;
;#else
;unsigned int rx_counter_usartf0=0;
;#endif
;
;// This flag is set on USARTF0 Receiver buffer overflow
;bit rx_buffer_overflow_usartf0=0;
;
;// USARTF0 Receiver interrupt service routine
;interrupt [USARTF0_RXC_vect] void usartf0_rx_isr(void)
; 0000 02A4 {
_usartf0_rx_isr:
; .FSTART _usartf0_rx_isr
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 02A5 unsigned char status;
; 0000 02A6 char data;
; 0000 02A7 int data0,data1,data2;
; 0000 02A8 
; 0000 02A9 status=USARTF0.STATUS;
	SBIW R28,2
	CALL __SAVELOCR6
;	status -> R17
;	data -> R16
;	data0 -> R18,R19
;	data1 -> R20,R21
;	data2 -> Y+6
	LDS  R17,2977
; 0000 02AA data=USARTF0.DATA;
	LDS  R16,2976
; 0000 02AB        /*
; 0000 02AC if ((status & (USART_FERR_bm | USART_PERR_bm | USART_BUFOVF_bm)) == 0)
; 0000 02AD    {
; 0000 02AE    rx_buffer_usartf0[rx_wr_index_usartf0++]=data;
; 0000 02AF    if(rx_wr_index_usartf0 == 5)
; 0000 02B0    {
; 0000 02B1    if(rx_buffer_usartf0[rx_wr_index_usartf0-5]=='A')
; 0000 02B2    {
; 0000 02B3    data0 = rx_buffer_usartf0[rx_wr_index_usartf0-4]-0x30;
; 0000 02B4    data1 = rx_buffer_usartf0[rx_wr_index_usartf0-3]-0x30;
; 0000 02B5    data2 = rx_buffer_usartf0[rx_wr_index_usartf0-2]-0x30;
; 0000 02B6 
; 0000 02B7    DAQ_data =  (data0*100) + ((data1)*10) + (data2);
; 0000 02B8    f_DAQ_data=(float)(DAQ_data*40.95);
; 0000 02B9    DAQ_data = (unsigned int) (f_DAQ_data);
; 0000 02BA    putchar (DAQ_data>>8);
; 0000 02BB    putchar (DAQ_data);
; 0000 02BC //   DAQ_data = 4095;
; 0000 02BD    rx_wr_index_usartf0=0;
; 0000 02BE    dacb_write(0,DAQ_data);
; 0000 02BF    }
; 0000 02C0    }
; 0000 02C1  //  putchar(rx_buffer_usartf0[(rx_wr_index_usartf0-1)]);
; 0000 02C2 #if RX_BUFFER_SIZE_USARTF0 == 256
; 0000 02C3    // special case for receiver buffer size=256
; 0000 02C4    if (++rx_counter_usartf0 == 0) rx_buffer_overflow_usartf0=1;
; 0000 02C5 #else
; 0000 02C6    if (rx_wr_index_usartf0 == RX_BUFFER_SIZE_USARTF0) rx_wr_index_usartf0=0;
; 0000 02C7    if (++rx_counter_usartf0 == RX_BUFFER_SIZE_USARTF0)
; 0000 02C8       {
; 0000 02C9       rx_counter_usartf0=0;
; 0000 02CA       rx_buffer_overflow_usartf0=1;
; 0000 02CB       }
; 0000 02CC #endif
; 0000 02CD    }*/
; 0000 02CE      if((data==start_byte)&&(packet_start==0))
	CP   R5,R16
	BRNE _0x7
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BREQ _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 02CF             {
; 0000 02D0             //packet start________________________________
; 0000 02D1             packet_start=1;                     //packet start
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 02D2             data_recieved = 0;                  //Byte Number Set
	CLR  R8
	CLR  R9
; 0000 02D3             requ_buffer[data_recieved]=data;  //Save data
	RJMP _0x59
; 0000 02D4             data_recieved++;                    //Byte Number Set For next Byte
; 0000 02D5             //____________________________________________
; 0000 02D6             }
; 0000 02D7         else if(packet_start==1)
_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xA
; 0000 02D8             {
; 0000 02D9             //packet end__________________________________
; 0000 02DA             if ( (data_recieved==(packet_size_request-1))&&(data==stop_byte))
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0xC
	CP   R4,R16
	BREQ _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 02DB                 {
; 0000 02DC                     packet_start=0;
	CLR  R10
	CLR  R11
; 0000 02DD                     requ_buffer[data_recieved]=data;  //Save data
	MOVW R30,R8
	CALL SUBOPT_0x0
; 0000 02DE                     data_recieved++;
; 0000 02DF                     flag=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 02E0 
; 0000 02E1                 }
; 0000 02E2             //____________________________________________
; 0000 02E3 
; 0000 02E4             //packet not end dnf__________________________
; 0000 02E5             else if ( (data_recieved==(packet_size_request-1))&&(data!=stop_byte))
	RJMP _0xE
_0xB:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x10
	CP   R4,R16
	BRNE _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 02E6                 {
; 0000 02E7                     packet_start=0;
	CLR  R10
	CLR  R11
; 0000 02E8                     data_recieved = 0;
	CLR  R8
	CLR  R9
; 0000 02E9                 }
; 0000 02EA             //____________________________________________
; 0000 02EB 
; 0000 02EC             //packet is ok yet__________________________
; 0000 02ED             else
	RJMP _0x12
_0xF:
; 0000 02EE                 {
; 0000 02EF                 requ_buffer[data_recieved]=data;  //Save data
_0x59:
	MOVW R30,R8
	CALL SUBOPT_0x0
; 0000 02F0                 data_recieved++;
; 0000 02F1                 }
_0x12:
_0xE:
; 0000 02F2             //________________________________putchar____________
; 0000 02F3             }
; 0000 02F4 
; 0000 02F5 
; 0000 02F6 }
_0xA:
	CALL __LOADLOCR6
	ADIW R28,8
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Receive a character from USARTF0
;// USARTF0 is used as the default input device by the 'getchar' function
;#define _ALTERNATE_GETCHAR_
;
;#pragma used+
;char getchar(void)
; 0000 02FE {
; 0000 02FF char data;
; 0000 0300 
; 0000 0301 while (rx_counter_usartf0==0);
;	data -> R17
; 0000 0302 data=rx_buffer_usartf0[rx_rd_index_usartf0++];
; 0000 0303 #if RX_BUFFER_SIZE_USARTF0 != 256
; 0000 0304 if (rx_rd_index_usartf0 == RX_BUFFER_SIZE_USARTF0) rx_rd_index_usartf0=0;
; 0000 0305 #endif
; 0000 0306 #asm("cli")
; 0000 0307 --rx_counter_usartf0;
; 0000 0308 #asm("sei")
; 0000 0309 return data;
; 0000 030A }
;#pragma used-
;
;// USARTF0 Transmitter buffer
;#define TX_BUFFER_SIZE_USARTF0 64
;char tx_buffer_usartf0[TX_BUFFER_SIZE_USARTF0];
;
;#if TX_BUFFER_SIZE_USARTF0 <= 256
;unsigned char tx_wr_index_usartf0=0,tx_rd_index_usartf0=0;
;#else
;unsigned int tx_wr_index_usartf0=0,tx_rd_index_usartf0=0;
;#endif
;
;#if TX_BUFFER_SIZE_USARTF0 < 256
;unsigned char tx_counter_usartf0=0;
;#else
;unsigned int tx_counter_usartf0=0;
;#endif
;
;// USARTF0 Transmitter interrupt service routine
;interrupt [USARTF0_TXC_vect] void usartf0_tx_isr(void)
; 0000 031F {
_usartf0_tx_isr:
; .FSTART _usartf0_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0320 if (tx_counter_usartf0)
	LDS  R30,_tx_counter_usartf0
	CPI  R30,0
	BREQ _0x17
; 0000 0321    {
; 0000 0322    --tx_counter_usartf0;
	SUBI R30,LOW(1)
	STS  _tx_counter_usartf0,R30
; 0000 0323    USARTF0.DATA=tx_buffer_usartf0[tx_rd_index_usartf0++];
	LDS  R30,_tx_rd_index_usartf0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index_usartf0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer_usartf0)
	SBCI R31,HIGH(-_tx_buffer_usartf0)
	LD   R30,Z
	STS  2976,R30
; 0000 0324 #if TX_BUFFER_SIZE_USARTF0 != 256
; 0000 0325    if (tx_rd_index_usartf0 == TX_BUFFER_SIZE_USARTF0) tx_rd_index_usartf0=0;
	LDS  R26,_tx_rd_index_usartf0
	CPI  R26,LOW(0x40)
	BRNE _0x18
	LDI  R30,LOW(0)
	STS  _tx_rd_index_usartf0,R30
; 0000 0326 #endif
; 0000 0327    }
_0x18:
; 0000 0328 }
_0x17:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Write a character to the USARTF0 Transmitter buffer
;// USARTF0 is used as the default output device by the 'putchar' function
;#define _ALTERNATE_PUTCHAR_
;
;#pragma used+
;void putchar(char c)
; 0000 0330 {
_putchar:
; .FSTART _putchar
; 0000 0331 while (tx_counter_usartf0 == TX_BUFFER_SIZE_USARTF0);
	ST   -Y,R26
;	c -> Y+0
_0x19:
	LDS  R26,_tx_counter_usartf0
	CPI  R26,LOW(0x40)
	BREQ _0x19
; 0000 0332 #asm("cli")
	cli
; 0000 0333 if (tx_counter_usartf0 || ((USARTF0.STATUS & USART_DREIF_bm)==0))
	LDS  R30,_tx_counter_usartf0
	CPI  R30,0
	BRNE _0x1D
	LDS  R30,2977
	ANDI R30,LOW(0x20)
	BRNE _0x1C
_0x1D:
; 0000 0334    {
; 0000 0335    tx_buffer_usartf0[tx_wr_index_usartf0++]=c;
	LDS  R30,_tx_wr_index_usartf0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index_usartf0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer_usartf0)
	SBCI R31,HIGH(-_tx_buffer_usartf0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0336 #if TX_BUFFER_SIZE_USARTF0 != 256
; 0000 0337    if (tx_wr_index_usartf0 == TX_BUFFER_SIZE_USARTF0) tx_wr_index_usartf0=0;
	LDS  R26,_tx_wr_index_usartf0
	CPI  R26,LOW(0x40)
	BRNE _0x1F
	LDI  R30,LOW(0)
	STS  _tx_wr_index_usartf0,R30
; 0000 0338 #endif
; 0000 0339    ++tx_counter_usartf0;
_0x1F:
	LDS  R30,_tx_counter_usartf0
	SUBI R30,-LOW(1)
	STS  _tx_counter_usartf0,R30
; 0000 033A    }
; 0000 033B else
	RJMP _0x20
_0x1C:
; 0000 033C    USARTF0.DATA=c;
	LD   R30,Y
	STS  2976,R30
; 0000 033D #asm("sei")
_0x20:
	sei
; 0000 033E }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;
;
;
;// DACB initialization
;void dacb_init(void)
; 0000 0345 {
_dacb_init:
; .FSTART _dacb_init
; 0000 0346 // Operating mode: Single Channel (Ch0)
; 0000 0347 // Channel 0 triggered by the event system: Off
; 0000 0348 DACB.CTRLB=(DACB.CTRLB & (~(DAC_CHSEL_gm | DAC_CH0TRIG_bm | DAC_CH1TRIG_bm))) |
; 0000 0349 	DAC_CHSEL_SINGLE_gc;
	LDS  R30,801
	ANDI R30,LOW(0x9C)
	STS  801,R30
; 0000 034A 
; 0000 034B // Reference: AREF on PORTB
; 0000 034C // Left adjust value: Off
; 0000 034D DACB.CTRLC=(DACB.CTRLC & (~(DAC_REFSEL_gm | DAC_LEFTADJ_bm))) |
; 0000 034E 	DAC_REFSEL_AREFB_gc;
	LDS  R30,802
	ANDI R30,LOW(0xE6)
	ORI  R30,LOW(0x18)
	STS  802,R30
; 0000 034F 
; 0000 0350 // DACB is enabled
; 0000 0351 // Low power mode: Off
; 0000 0352 // Channel 0 output: On
; 0000 0353 // Channel 1 output: Off
; 0000 0354 // Internal output connected to the ADCB and Analog Comparator MUX-es: Off
; 0000 0355 DACB.CTRLA=(DACB.CTRLA & (~(DAC_IDOEN_bm | DAC_CH0EN_bm | DAC_CH1EN_bm | DAC_LPMODE_bm))) |
; 0000 0356 	DAC_CH0EN_bm | DAC_ENABLE_bm;
	LDS  R30,800
	ANDI R30,LOW(0xE1)
	ORI  R30,LOW(0x5)
	STS  800,R30
; 0000 0357 }
	RET
; .FEND
;
;// Function used to write data to a DACB channel ch
;void dacb_write(unsigned char ch, unsigned int data)
; 0000 035B {
_dacb_write:
; .FSTART _dacb_write
; 0000 035C register unsigned char m=ch ? DAC_CH1DRE_bm : DAC_CH0DRE_bm;
; 0000 035D // Wait for the channel data register to be ready for new data
; 0000 035E while ((DACB.STATUS & m)==0);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	ch -> Y+3
;	data -> Y+1
;	m -> R17
	LDD  R30,Y+3
	CPI  R30,0
	BREQ _0x21
	LDI  R30,LOW(2)
	RJMP _0x22
_0x21:
	LDI  R30,LOW(1)
_0x22:
	MOV  R17,R30
_0x24:
	LDS  R30,805
	AND  R30,R17
	BREQ _0x24
; 0000 035F // Write new data to the channel data register
; 0000 0360 if (m==DAC_CH1DRE_bm) DACB.CH1DATA=data;
	CPI  R17,2
	BRNE _0x27
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	STS  826,R30
	STS  826+1,R31
; 0000 0361 else DACB.CH0DATA=data;
	RJMP _0x28
_0x27:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	STS  824,R30
	STS  824+1,R31
; 0000 0362 }
_0x28:
	LDD  R17,Y+0
	ADIW R28,4
	RET
; .FEND
;// Disable a Timer/Counter type TC0
;void tc0_disable(TC0_t *ptc)
; 0000 0365 {
_tc0_disable:
; .FSTART _tc0_disable
; 0000 0366 // Timer/Counter off
; 0000 0367 ptc->CTRLA=TC_CLKSEL_OFF_gc;
	ST   -Y,R27
	ST   -Y,R26
;	*ptc -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0368 // Issue a reset command
; 0000 0369 ptc->CTRLFSET=TC_CMD_RESET_gc;
	ADIW R26,9
	LDI  R30,LOW(12)
	ST   X,R30
; 0000 036A }
	RJMP _0x2060003
; .FEND
;
;// Timer/Counter TCC0 initialization
;void tcc0_init(void)
; 0000 036E {
_tcc0_init:
; .FSTART _tcc0_init
; 0000 036F unsigned char s;
; 0000 0370 unsigned char n;
; 0000 0371 
; 0000 0372 // Note: The correct PORTC direction for the Compare Channels
; 0000 0373 // outputs is configured in the ports_init function.
; 0000 0374 
; 0000 0375 // Save interrupts enabled/disabled state
; 0000 0376 s=SREG;
	ST   -Y,R17
	ST   -Y,R16
;	s -> R17
;	n -> R16
	IN   R17,63
; 0000 0377 // Disable interrupts
; 0000 0378 #asm("cli")
	cli
; 0000 0379 
; 0000 037A // Disable and reset the timer/counter just to be sure
; 0000 037B tc0_disable(&TCC0);
	LDI  R26,LOW(2048)
	LDI  R27,HIGH(2048)
	RCALL _tc0_disable
; 0000 037C // Clock source: ClkPer/1
; 0000 037D TCC0.CTRLA=TC_CLKSEL_DIV1_gc;
	LDI  R30,LOW(1)
	STS  2048,R30
; 0000 037E // Mode: Single Slope PWM Gen., Overflow Int./Event on BOTTOM
; 0000 037F // Compare/Capture on channel A: On
; 0000 0380 // Compare/Capture on channel B: On
; 0000 0381 // Compare/Capture on channel C: On
; 0000 0382 // Compare/Capture on channel D: Off
; 0000 0383 TCC0.CTRLB=(0<<TC0_CCDEN_bp) | (1<<TC0_CCCEN_bp) | (1<<TC0_CCBEN_bp) | (1<<TC0_CCAEN_bp) |
; 0000 0384 	TC_WGMODE_SS_gc;
	LDI  R30,LOW(115)
	STS  2049,R30
; 0000 0385 // Capture event source: None
; 0000 0386 // Capture event action: None
; 0000 0387 TCC0.CTRLD=TC_EVACT_OFF_gc | TC_EVSEL_OFF_gc;
	LDI  R30,LOW(0)
	STS  2051,R30
; 0000 0388 
; 0000 0389 // Set Timer/Counter in Normal mode
; 0000 038A TCC0.CTRLE=TC_BYTEM_NORMAL_gc;
	STS  2052,R30
; 0000 038B 
; 0000 038C // Overflow interrupt: Disabled
; 0000 038D // Error interrupt: Disabled
; 0000 038E TCC0.INTCTRLA=TC_ERRINTLVL_OFF_gc | TC_OVFINTLVL_OFF_gc;
	STS  2054,R30
; 0000 038F 
; 0000 0390 // Compare/Capture channel A interrupt: Disabled
; 0000 0391 // Compare/Capture channel B interrupt: Disabled
; 0000 0392 // Compare/Capture channel C interrupt: Disabled
; 0000 0393 // Compare/Capture channel D interrupt: Disabled
; 0000 0394 TCC0.INTCTRLB=TC_CCDINTLVL_OFF_gc | TC_CCCINTLVL_OFF_gc | TC_CCBINTLVL_OFF_gc | TC_CCAINTLVL_OFF_gc;
	STS  2055,R30
; 0000 0395 
; 0000 0396 // High resolution extension: Off
; 0000 0397 HIRESC.CTRLA&= ~HIRES_HREN0_bm;
	LDS  R30,2192
	ANDI R30,0xFE
	STS  2192,R30
; 0000 0398 
; 0000 0399 // Advanced Waveform Extension initialization
; 0000 039A // Optimize for speed
; 0000 039B #pragma optsize-
; 0000 039C // Disable locking the AWEX configuration registers just to be sure
; 0000 039D n=MCU.AWEXLOCK & (~MCU_AWEXCLOCK_bm);
	LDS  R30,153
	ANDI R30,0xFE
	MOV  R16,R30
; 0000 039E CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 039F MCU.AWEXLOCK=n;
	STS  153,R16
; 0000 03A0 // Restore optimization for size if needed
; 0000 03A1 #pragma optsize_default
; 0000 03A2 
; 0000 03A3 // Pattern generation: Off
; 0000 03A4 // Common waveform channel mode: Off
; 0000 03A5 // Dead time insertion for compare channel A: Off
; 0000 03A6 // Dead time insertion for compare channel B: Off
; 0000 03A7 // Dead time insertion for compare channel C: Off
; 0000 03A8 // Dead time insertion for compare channel D: Off
; 0000 03A9 AWEXC.CTRL=(0<<AWEX_PGM_bp) | (0<<AWEX_CWCM_bp) | (0<<AWEX_DTICCDEN_bp) | (0<<AWEX_DTICCCEN_bp) |
; 0000 03AA 	(0<<AWEX_DTICCBEN_bp) | (0<<AWEX_DTICCAEN_bp);
	LDI  R30,LOW(0)
	STS  2176,R30
; 0000 03AB // Low side dead time duration [ClkPer cycles]
; 0000 03AC AWEXC.DTLS=0;
	STS  2184,R30
; 0000 03AD // High side dead time duration [ClkPer cycles]
; 0000 03AE AWEXC.DTHS=0;
	STS  2185,R30
; 0000 03AF // PORTC output register override
; 0000 03B0 AWEXC.OUTOVEN=0b00000000;
	STS  2188,R30
; 0000 03B1 
; 0000 03B2 // Fault protection initialization
; 0000 03B3 // Fault detection on OCD Break detection: On
; 0000 03B4 // Fault detection restart mode: Latched Mode
; 0000 03B5 // Fault detection action: None (Fault protection disabled)
; 0000 03B6 AWEXC.FDCTRL=(AWEXC.FDCTRL & (~(AWEX_FDDBD_bm | AWEX_FDMODE_bm | AWEX_FDACT_gm))) |
; 0000 03B7 	(0<<AWEX_FDDBD_bp) | (0<<AWEX_FDMODE_bp) | AWEX_FDACT_NONE_gc;
	LDS  R30,2179
	ANDI R30,LOW(0xE8)
	STS  2179,R30
; 0000 03B8 // Fault detect events:
; 0000 03B9 // Event channel 0: Off
; 0000 03BA // Event channel 1: Off
; 0000 03BB // Event channel 2: Off
; 0000 03BC // Event channel 3: Off
; 0000 03BD // Event channel 4: Off
; 0000 03BE // Event channel 5: Off
; 0000 03BF // Event channel 6: Off
; 0000 03C0 // Event channel 7: Off
; 0000 03C1 AWEXC.FDEMASK=0b00000000;
	LDI  R30,LOW(0)
	STS  2178,R30
; 0000 03C2 // Make sure the fault detect flag is cleared
; 0000 03C3 AWEXC.STATUS|=AWEXC.STATUS & AWEX_FDF_bm;
	LDI  R26,LOW(2180)
	LDI  R27,HIGH(2180)
	MOV  R0,R26
	LD   R26,X
	LDS  R30,2180
	ANDI R30,LOW(0x4)
	OR   R30,R26
	MOV  R26,R0
	ST   X,R30
; 0000 03C4 
; 0000 03C5 // Clear the interrupt flags
; 0000 03C6 TCC0.INTFLAGS=TCC0.INTFLAGS;
	LDS  R30,2060
	STS  2060,R30
; 0000 03C7 // Set Counter register
; 0000 03C8 TCC0.CNT=0x0000;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  2080,R30
	STS  2080+1,R31
; 0000 03C9 // Set Period register
; 0000 03CA TCC0.PER=0x013F;
	LDI  R30,LOW(319)
	LDI  R31,HIGH(319)
	STS  2086,R30
	STS  2086+1,R31
; 0000 03CB // Set channel A Compare/Capture register
; 0000 03CC TCC0.CCA=0x0000;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  2088,R30
	STS  2088+1,R31
; 0000 03CD // Set channel B Compare/Capture register
; 0000 03CE TCC0.CCB=0x0000;
	STS  2090,R30
	STS  2090+1,R31
; 0000 03CF // Set channel C Compare/Capture register
; 0000 03D0 TCC0.CCC=0x0000;
	STS  2092,R30
	STS  2092+1,R31
; 0000 03D1 // Set channel D Compare/Capture register
; 0000 03D2 TCC0.CCD=0x0000;
	STS  2094,R30
	STS  2094+1,R31
; 0000 03D3 
; 0000 03D4 // Restore interrupts enabled/disabled state
; 0000 03D5 SREG=s;
	OUT  0x3F,R17
; 0000 03D6 }
_0x2060004:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;
;// Function used to read the calibration byte from the
;// signature row, specified by 'index'
;#pragma optsize-
;unsigned char read_calibration_byte(unsigned char index)
; 0000 03DE {
_read_calibration_byte:
; .FSTART _read_calibration_byte
; 0000 03DF unsigned char r;
; 0000 03E0 NVM.CMD=NVM_CMD_READ_CALIB_ROW_gc;
	ST   -Y,R26
	ST   -Y,R17
;	index -> Y+1
;	r -> R17
	LDI  R30,LOW(2)
	STS  458,R30
; 0000 03E1 r=*((flash unsigned char*) index);
	LDD  R30,Y+1
	LDI  R31,0
	LPM  R17,Z
; 0000 03E2 // Clean up NVM command register
; 0000 03E3 NVM.CMD=NVM_CMD_NO_OPERATION_gc;
	LDI  R30,LOW(0)
	STS  458,R30
; 0000 03E4 return r;
	MOV  R30,R17
	LDD  R17,Y+0
_0x2060003:
	ADIW R28,2
	RET
; 0000 03E5 }
; .FEND
;#pragma optsize_default
;// ADCA initialization
;void adca_init(void)
; 0000 03E9 {
_adca_init:
; .FSTART _adca_init
; 0000 03EA // ADCA is enabled
; 0000 03EB // Resolution: 12 Bits
; 0000 03EC // Load the calibration value for 12 Bit resolution
; 0000 03ED // from the signature row
; 0000 03EE ADCA.CALL=read_calibration_byte(PROD_SIGNATURES_START+ADCACAL0_offset);
	LDI  R26,LOW(32)
	RCALL _read_calibration_byte
	STS  524,R30
; 0000 03EF ADCA.CALH=read_calibration_byte(PROD_SIGNATURES_START+ADCACAL1_offset);
	LDI  R26,LOW(33)
	RCALL _read_calibration_byte
	STS  525,R30
; 0000 03F0 
; 0000 03F1 // Free Running mode: Off
; 0000 03F2 // Gain stage impedance mode: High-impedance sources
; 0000 03F3 // Current consumption: No limit
; 0000 03F4 // Conversion mode: Unsigned
; 0000 03F5 ADCA.CTRLB=(0<<ADC_IMPMODE_bp) | ADC_CURRLIMIT_NO_gc | (0<<ADC_CONMODE_bp) | ADC_RESOLUTION_12BIT_gc;
	LDI  R30,LOW(0)
	STS  513,R30
; 0000 03F6 
; 0000 03F7 // Clock frequency: 2000.000 kHz
; 0000 03F8 ADCA.PRESCALER=ADC_PRESCALER_DIV16_gc;
	LDI  R30,LOW(2)
	STS  516,R30
; 0000 03F9 
; 0000 03FA // Reference: AREF pin on PORTA
; 0000 03FB // Temperature reference: Off
; 0000 03FC ADCA.REFCTRL=ADC_REFSEL_AREFA_gc | (0<<ADC_TEMPREF_bp) | (0<<ADC_BANDGAP_bp);
	LDI  R30,LOW(32)
	STS  514,R30
; 0000 03FD 
; 0000 03FE // Initialize the ADC Compare register
; 0000 03FF ADCA.CMPL=0x00;
	LDI  R30,LOW(0)
	STS  536,R30
; 0000 0400 ADCA.CMPH=0x00;
	STS  537,R30
; 0000 0401 
; 0000 0402 // ADC channel 0 gain: 1
; 0000 0403 // ADC channel 0 input mode: Single-ended positive input signal
; 0000 0404 ADCA.CH0.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	LDI  R30,LOW(1)
	STS  544,R30
; 0000 0405 
; 0000 0406 // ADC channel 0 positive input: ADC1 pin
; 0000 0407 // ADC channel 0 negative input: GND
; 0000 0408 ADCA.CH0.MUXCTRL=ADC_CH_MUXPOS_PIN1_gc;
	LDI  R30,LOW(8)
	STS  545,R30
; 0000 0409 
; 0000 040A // ADC channel 1 gain: 1
; 0000 040B // ADC channel 1 input mode: Single-ended positive input signal
; 0000 040C ADCA.CH1.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	LDI  R30,LOW(1)
	STS  552,R30
; 0000 040D 
; 0000 040E // ADC channel 1 positive input: ADC2 pin
; 0000 040F // ADC channel 1 negative input: GND
; 0000 0410 ADCA.CH1.MUXCTRL=ADC_CH_MUXPOS_PIN2_gc;
	LDI  R30,LOW(16)
	STS  553,R30
; 0000 0411 
; 0000 0412 // ADC channel 2 gain: 1
; 0000 0413 // ADC channel 2 input mode: Single-ended positive input signal
; 0000 0414 ADCA.CH2.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	LDI  R30,LOW(1)
	STS  560,R30
; 0000 0415 
; 0000 0416 // ADC channel 2 positive input: ADC3 pin
; 0000 0417 // ADC channel 2 negative input: GND
; 0000 0418 ADCA.CH2.MUXCTRL=ADC_CH_MUXPOS_PIN3_gc;
	LDI  R30,LOW(24)
	STS  561,R30
; 0000 0419 
; 0000 041A // ADC channel 3 gain: 1
; 0000 041B // ADC channel 3 input mode: Single-ended positive input signal
; 0000 041C ADCA.CH3.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	LDI  R30,LOW(1)
	STS  568,R30
; 0000 041D 
; 0000 041E // ADC channel 3 positive input: ADC4 pin
; 0000 041F // ADC channel 3 negative input: GND
; 0000 0420 ADCA.CH3.MUXCTRL=ADC_CH_MUXPOS_PIN4_gc;
	LDI  R30,LOW(32)
	STS  569,R30
; 0000 0421 
; 0000 0422 // AD conversion is started by software
; 0000 0423 ADCA.EVCTRL=ADC_EVACT_NONE_gc;
	LDI  R30,LOW(0)
	STS  515,R30
; 0000 0424 
; 0000 0425 // Channel 0 interrupt: Disabled
; 0000 0426 ADCA.CH0.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  546,R30
; 0000 0427 // Channel 1 interrupt: Disabled
; 0000 0428 ADCA.CH1.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  554,R30
; 0000 0429 // Channel 2 interrupt: Disabled
; 0000 042A ADCA.CH2.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  562,R30
; 0000 042B // Channel 3 interrupt: Disabled
; 0000 042C ADCA.CH3.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  570,R30
; 0000 042D 
; 0000 042E // Enable the ADC
; 0000 042F ADCA.CTRLA|=ADC_ENABLE_bm;
	LDS  R30,512
	ORI  R30,1
	STS  512,R30
; 0000 0430 // Insert a delay to allow the ADC common mode voltage to stabilize
; 0000 0431 delay_us(2);
	RJMP _0x2060002
; 0000 0432 }
; .FEND
;
;// ADCA channel data read function using polled mode
;unsigned int adca_read(unsigned char channel)
; 0000 0436 {
_adca_read:
; .FSTART _adca_read
; 0000 0437 ADC_CH_t *pch=&ADCA.CH0+channel;
; 0000 0438 unsigned int data;
; 0000 0439 
; 0000 043A // Start the AD conversion
; 0000 043B pch->CTRL|= 1<<ADC_CH_START_bp;
	ST   -Y,R26
	CALL __SAVELOCR4
;	channel -> Y+4
;	*pch -> R16,R17
;	data -> R18,R19
	LDD  R30,Y+4
	LDI  R31,0
	LDI  R26,LOW(544)
	LDI  R27,HIGH(544)
	CALL SUBOPT_0x1
; 0000 043C // Wait for the AD conversion to complete
; 0000 043D while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
_0x29:
	MOVW R30,R16
	LDD  R26,Z+3
	ANDI R26,LOW(0x1)
	BREQ _0x29
; 0000 043E // Clear the interrupt flag
; 0000 043F pch->INTFLAGS=ADC_CH_CHIF_bm;
	RJMP _0x2060001
; 0000 0440 // Read the AD conversion result
; 0000 0441 ((unsigned char *) &data)[0]=pch->RESL;
; 0000 0442 ((unsigned char *) &data)[1]=pch->RESH;
; 0000 0443 return data;
; 0000 0444 }
; .FEND
;
;// ADCA sweeped channel(s) data read function
;// for software triggered mode
;void adca_sweep_read(unsigned char nch, unsigned int *pdata)
; 0000 0449 {
; 0000 044A ADC_CH_t *pch=&ADCA.CH0;
; 0000 044B unsigned char i,j,m;
; 0000 044C 
; 0000 044D // Sweep starts with channel 0
; 0000 044E j=ADC_CH0START_bm;
;	nch -> Y+8
;	*pdata -> Y+6
;	*pch -> R16,R17
;	i -> R19
;	j -> R18
;	m -> R21
; 0000 044F // Prepare the AD conversion start mask for the sweeped channel(s)
; 0000 0450 m=0;
; 0000 0451 i=0;
; 0000 0452 do
; 0000 0453   {
; 0000 0454   m|=j;
; 0000 0455   j<<=1;
; 0000 0456   }
; 0000 0457 while (++i<nch);
; 0000 0458 // Ensure the interrupt flags are cleared
; 0000 0459 ADCA.INTFLAGS=ADCA.INTFLAGS;
; 0000 045A // Start the AD conversion for the sweeped channel(s)
; 0000 045B ADCA.CTRLA=(ADCA.CTRLA & (ADC_DMASEL_gm | ADC_FLUSH_bm | ADC_ENABLE_bm)) | m;
; 0000 045C // Read and store the AD conversion results for all the sweeped channels
; 0000 045D for (i=0; i<nch; i++)
; 0000 045E     {
; 0000 045F     // Wait for the AD conversion to complete
; 0000 0460     while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
; 0000 0461     // Clear the interrupt flag
; 0000 0462     pch->INTFLAGS=ADC_CH_CHIF_bm;
; 0000 0463     // Read the AD conversion result
; 0000 0464     ((unsigned char *) pdata)[0]=pch->RESL;
; 0000 0465     ((unsigned char *) pdata)[1]=pch->RESH;
; 0000 0466     pdata++;
; 0000 0467     pch++;
; 0000 0468     }
; 0000 0469 }
;
;// ADCB initialization
;void adcb_init(void)
; 0000 046D {
_adcb_init:
; .FSTART _adcb_init
; 0000 046E // ADCB is enabled
; 0000 046F // Resolution: 12 Bits
; 0000 0470 // Load the calibration value for 12 Bit resolution
; 0000 0471 // from the signature row
; 0000 0472 ADCB.CALL=read_calibration_byte(PROD_SIGNATURES_START+ADCBCAL0_offset);
	LDI  R26,LOW(36)
	RCALL _read_calibration_byte
	STS  588,R30
; 0000 0473 ADCB.CALH=read_calibration_byte(PROD_SIGNATURES_START+ADCBCAL1_offset);
	LDI  R26,LOW(37)
	RCALL _read_calibration_byte
	STS  589,R30
; 0000 0474 
; 0000 0475 // Free Running mode: Off
; 0000 0476 // Gain stage impedance mode: High-impedance sources
; 0000 0477 // Current consumption: No limit
; 0000 0478 // Conversion mode: Unsigned
; 0000 0479 ADCB.CTRLB=(0<<ADC_IMPMODE_bp) | ADC_CURRLIMIT_NO_gc | (0<<ADC_CONMODE_bp) | ADC_RESOLUTION_12BIT_gc;
	LDI  R30,LOW(0)
	STS  577,R30
; 0000 047A 
; 0000 047B // Clock frequency: 2000.000 kHz
; 0000 047C ADCB.PRESCALER=ADC_PRESCALER_DIV16_gc;
	LDI  R30,LOW(2)
	STS  580,R30
; 0000 047D 
; 0000 047E // Reference: AREF pin on PORTA
; 0000 047F // Temperature reference: On
; 0000 0480 ADCB.REFCTRL=ADC_REFSEL_AREFA_gc | (1<<ADC_TEMPREF_bp) | (0<<ADC_BANDGAP_bp);
	LDI  R30,LOW(33)
	STS  578,R30
; 0000 0481 
; 0000 0482 // Initialize the ADC Compare register
; 0000 0483 ADCB.CMPL=0x00;
	LDI  R30,LOW(0)
	STS  600,R30
; 0000 0484 ADCB.CMPH=0x00;
	STS  601,R30
; 0000 0485 
; 0000 0486 // ADC channel 0 gain: 1
; 0000 0487 // ADC channel 0 input mode: Single-ended positive input signal
; 0000 0488 ADCB.CH0.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	LDI  R30,LOW(1)
	STS  608,R30
; 0000 0489 
; 0000 048A // ADC channel 0 positive input: ADC1 pin
; 0000 048B // ADC channel 0 negative input: GND
; 0000 048C ADCB.CH0.MUXCTRL=ADC_CH_MUXPOS_PIN1_gc;
	LDI  R30,LOW(8)
	STS  609,R30
; 0000 048D 
; 0000 048E // ADC channel 1 gain: 1
; 0000 048F // ADC channel 1 input mode: Single-ended positive input signal
; 0000 0490 ADCB.CH1.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	LDI  R30,LOW(1)
	STS  616,R30
; 0000 0491 
; 0000 0492 // ADC channel 1 positive input: ADC3 pin
; 0000 0493 // ADC channel 1 negative input: GND
; 0000 0494 ADCB.CH1.MUXCTRL=ADC_CH_MUXPOS_PIN3_gc;
	LDI  R30,LOW(24)
	STS  617,R30
; 0000 0495 
; 0000 0496 // ADC channel 2 gain: 1
; 0000 0497 // ADC channel 2 input mode: Internal positive input signal
; 0000 0498 ADCB.CH2.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_INTERNAL_gc;
	LDI  R30,LOW(0)
	STS  624,R30
; 0000 0499 
; 0000 049A // ADC channel 2 positive input: Temp. Reference
; 0000 049B // ADC channel 2 negative input: GND
; 0000 049C ADCB.CH2.MUXCTRL=ADC_CH_MUXINT_TEMP_gc;
	STS  625,R30
; 0000 049D 
; 0000 049E // ADC channel 3 gain: 1
; 0000 049F // ADC channel 3 input mode: Internal positive input signal
; 0000 04A0 ADCB.CH3.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_INTERNAL_gc;
	STS  632,R30
; 0000 04A1 
; 0000 04A2 // ADC channel 3 positive input: Temp. Reference
; 0000 04A3 // ADC channel 3 negative input: GND
; 0000 04A4 ADCB.CH3.MUXCTRL=ADC_CH_MUXINT_TEMP_gc;
	STS  633,R30
; 0000 04A5 
; 0000 04A6 // AD conversion is started by software
; 0000 04A7 ADCB.EVCTRL=ADC_EVACT_NONE_gc;
	STS  579,R30
; 0000 04A8 
; 0000 04A9 // Channel 0 interrupt: Disabled
; 0000 04AA ADCB.CH0.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  610,R30
; 0000 04AB // Channel 1 interrupt: Disabled
; 0000 04AC ADCB.CH1.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  618,R30
; 0000 04AD // Channel 2 interrupt: Disabled
; 0000 04AE ADCB.CH2.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  626,R30
; 0000 04AF // Channel 3 interrupt: Disabled
; 0000 04B0 ADCB.CH3.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
	STS  634,R30
; 0000 04B1 
; 0000 04B2 // Enable the ADC
; 0000 04B3 ADCB.CTRLA|=ADC_ENABLE_bm;
	LDS  R30,576
	ORI  R30,1
	STS  576,R30
; 0000 04B4 // Insert a delay to allow the ADC common mode voltage to stabilize
; 0000 04B5 delay_us(2);
_0x2060002:
	__DELAY_USB 21
; 0000 04B6 }
	RET
; .FEND
;
;// ADCB channel data read function using polled mode
;unsigned int adcb_read(unsigned char channel)
; 0000 04BA {
_adcb_read:
; .FSTART _adcb_read
; 0000 04BB ADC_CH_t *pch=&ADCB.CH0+channel;
; 0000 04BC unsigned int data;
; 0000 04BD 
; 0000 04BE // Start the AD conversion
; 0000 04BF pch->CTRL|= 1<<ADC_CH_START_bp;
	ST   -Y,R26
	CALL __SAVELOCR4
;	channel -> Y+4
;	*pch -> R16,R17
;	data -> R18,R19
	LDD  R30,Y+4
	LDI  R31,0
	LDI  R26,LOW(608)
	LDI  R27,HIGH(608)
	CALL SUBOPT_0x1
; 0000 04C0 // Wait for the AD conversion to complete
; 0000 04C1 while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
_0x35:
	MOVW R30,R16
	LDD  R26,Z+3
	ANDI R26,LOW(0x1)
	BREQ _0x35
; 0000 04C2 // Clear the interrupt flag
; 0000 04C3 pch->INTFLAGS=ADC_CH_CHIF_bm;
_0x2060001:
	MOVW R26,R16
	ADIW R26,3
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 04C4 // Read the AD conversion result
; 0000 04C5 ((unsigned char *) &data)[0]=pch->RESL;
	MOVW R30,R16
	LDD  R18,Z+4
; 0000 04C6 ((unsigned char *) &data)[1]=pch->RESH;
	LDD  R19,Z+5
; 0000 04C7 return data;
	MOVW R30,R18
	CALL __LOADLOCR4
	ADIW R28,5
	RET
; 0000 04C8 }
; .FEND
;
;// ADCB sweeped channel(s) data read function
;// for software triggered mode
;void adcb_sweep_read(unsigned char nch, unsigned int *pdata)
; 0000 04CD {
; 0000 04CE ADC_CH_t *pch=&ADCB.CH0;
; 0000 04CF unsigned char i,j,m;
; 0000 04D0 
; 0000 04D1 // Sweep starts with channel 0
; 0000 04D2 j=ADC_CH0START_bm;
;	nch -> Y+8
;	*pdata -> Y+6
;	*pch -> R16,R17
;	i -> R19
;	j -> R18
;	m -> R21
; 0000 04D3 // Prepare the AD conversion start mask for the sweeped channel(s)
; 0000 04D4 m=0;
; 0000 04D5 i=0;
; 0000 04D6 do
; 0000 04D7   {
; 0000 04D8   m|=j;
; 0000 04D9   j<<=1;
; 0000 04DA   }
; 0000 04DB while (++i<nch);
; 0000 04DC // Ensure the interrupt flags are cleared
; 0000 04DD ADCB.INTFLAGS=ADCB.INTFLAGS;
; 0000 04DE // Start the AD conversion for the sweeped channel(s)
; 0000 04DF ADCB.CTRLA=(ADCB.CTRLA & (ADC_DMASEL_gm | ADC_FLUSH_bm | ADC_ENABLE_bm)) | m;
; 0000 04E0 // Read and store the AD conversion results for all the sweeped channels
; 0000 04E1 for (i=0; i<nch; i++)
; 0000 04E2     {
; 0000 04E3     // Wait for the AD conversion to complete
; 0000 04E4     while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
; 0000 04E5     // Clear the interrupt flag
; 0000 04E6     pch->INTFLAGS=ADC_CH_CHIF_bm;
; 0000 04E7     // Read the AD conversion result
; 0000 04E8     ((unsigned char *) pdata)[0]=pch->RESL;
; 0000 04E9     ((unsigned char *) pdata)[1]=pch->RESH;
; 0000 04EA     pdata++;
; 0000 04EB     pch++;
; 0000 04EC     }
; 0000 04ED }
;
;void main(void)
; 0000 04F0 {
_main:
; .FSTART _main
; 0000 04F1 // Declare your local variables here
; 0000 04F2 unsigned char n;
; 0000 04F3 int i;
; 0000 04F4 unsigned int ADCA_data,ai;
; 0000 04F5 unsigned char send_data[14];
; 0000 04F6 unsigned char data_DIG;
; 0000 04F7 
; 0000 04F8 // Interrupt system initialization
; 0000 04F9 // Optimize for speed
; 0000 04FA #pragma optsize-
; 0000 04FB // Make sure the interrupts are disabled
; 0000 04FC #asm("cli")
	SBIW R28,16
;	n -> R17
;	i -> R18,R19
;	ADCA_data -> R20,R21
;	ai -> Y+14
;	send_data -> Y+0
;	data_DIG -> R16
	cli
; 0000 04FD // Low level interrupt: Off
; 0000 04FE // Round-robin scheduling for low level interrupt: Off
; 0000 04FF // Medium level interrupt: On
; 0000 0500 // High level interrupt: On
; 0000 0501 // The interrupt vectors will be placed at the start of the Application FLASH section
; 0000 0502 n=(PMIC.CTRL & (~(PMIC_RREN_bm | PMIC_IVSEL_bm | PMIC_HILVLEN_bm | PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm))) |
; 0000 0503     PMIC_MEDLVLEN_bm | PMIC_HILVLEN_bm;
	LDS  R30,162
	ANDI R30,LOW(0x38)
	ORI  R30,LOW(0x6)
	MOV  R17,R30
; 0000 0504 CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 0505 PMIC.CTRL=n;
	STS  162,R17
; 0000 0506 // Set the default priority for round-robin scheduling
; 0000 0507 PMIC.INTPRI=0x00;
	LDI  R30,LOW(0)
	STS  161,R30
; 0000 0508 // Restore optimization for size if needed
; 0000 0509 #pragma optsize_default
; 0000 050A 
; 0000 050B // System clocks initialization
; 0000 050C system_clocks_init();
	RCALL _system_clocks_init
; 0000 050D 
; 0000 050E // Event system initialization
; 0000 050F event_system_init();
	RCALL _event_system_init
; 0000 0510 
; 0000 0511 // Ports initialization
; 0000 0512 ports_init();
	RCALL _ports_init
; 0000 0513 
; 0000 0514 // Virtual Ports initialization
; 0000 0515 vports_init();
	RCALL _vports_init
; 0000 0516 
; 0000 0517 // USARTF0 initialization
; 0000 0518 usartf0_init();
	RCALL _usartf0_init
; 0000 0519 
; 0000 051A dacb_init();
	RCALL _dacb_init
; 0000 051B 
; 0000 051C tcc0_init();
	RCALL _tcc0_init
; 0000 051D 
; 0000 051E adca_init();
	RCALL _adca_init
; 0000 051F adcb_init();
	RCALL _adcb_init
; 0000 0520 
; 0000 0521 // Globally enable interrupts
; 0000 0522 #asm("sei")
	sei
; 0000 0523 
; 0000 0524 while (1)
_0x41:
; 0000 0525       {
; 0000 0526            if(flag)
	MOV  R0,R6
	OR   R0,R7
	BRNE PC+2
	RJMP _0x44
; 0000 0527            {
; 0000 0528            flag=0;
	CLR  R6
	CLR  R7
; 0000 0529            DAC_data = (requ_buffer[1]*256)+requ_buffer[2];//dac init
	__GETB2MN _requ_buffer,1
	CALL SUBOPT_0x2
	__GETB1MN _requ_buffer,2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R12,R30
; 0000 052A 
; 0000 052B            for(i=0;i<=11;i++)
	__GETWRN 18,19,0
_0x46:
	__CPWRN 18,19,12
	BRGE _0x47
; 0000 052C            putchar(requ_buffer[i]);
	LDI  R26,LOW(_requ_buffer)
	LDI  R27,HIGH(_requ_buffer)
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	RCALL _putchar
	__ADDWRN 18,19,1
	RJMP _0x46
_0x47:
; 0000 052E dacb_write(0,DAC_data);
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R12
	RCALL _dacb_write
; 0000 052F 
; 0000 0530            TCC0.CCA = ((requ_buffer[3]*256)+requ_buffer[4])/12.84;//PWM A init
	__GETB2MN _requ_buffer,3
	CALL SUBOPT_0x2
	__GETB1MN _requ_buffer,4
	CALL SUBOPT_0x3
	LDI  R26,LOW(2088)
	LDI  R27,HIGH(2088)
	CALL SUBOPT_0x4
; 0000 0531            TCC0.CCB = ((requ_buffer[5]*256)+requ_buffer[6])/12.84;//PWM B init
	__GETB2MN _requ_buffer,5
	CALL SUBOPT_0x2
	__GETB1MN _requ_buffer,6
	CALL SUBOPT_0x3
	LDI  R26,LOW(2090)
	LDI  R27,HIGH(2090)
	CALL SUBOPT_0x4
; 0000 0532            TCC0.CCC = ((requ_buffer[7]*256)+requ_buffer[8])/12.84;//PWM C init
	__GETB2MN _requ_buffer,7
	CALL SUBOPT_0x2
	__GETB1MN _requ_buffer,8
	CALL SUBOPT_0x3
	LDI  R26,LOW(2092)
	LDI  R27,HIGH(2092)
	CALL SUBOPT_0x4
; 0000 0533            PORTE.OUT = ((requ_buffer[9]<<4)&0xF0)|((requ_buffer[10]>>4&0X0F));
	__GETB1MN _requ_buffer,9
	SWAP R30
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	__GETB1MN _requ_buffer,10
	SWAP R30
	ANDI R30,LOW(0xF)
	OR   R30,R26
	STS  1668,R30
; 0000 0534            if(requ_buffer[10]&0X01)
	__GETB1MN _requ_buffer,10
	ANDI R30,LOW(0x1)
	BREQ _0x48
; 0000 0535            PORTD.OUTSET = 0X10;
	LDI  R30,LOW(16)
	STS  1637,R30
; 0000 0536            else
	RJMP _0x49
_0x48:
; 0000 0537            PORTD.OUTCLR = 0X10;
	LDI  R30,LOW(16)
	STS  1638,R30
; 0000 0538            if(requ_buffer[10]&0X02)
_0x49:
	__GETB1MN _requ_buffer,10
	ANDI R30,LOW(0x2)
	BREQ _0x4A
; 0000 0539            PORTD.OUTSET = 0X20;
	LDI  R30,LOW(32)
	STS  1637,R30
; 0000 053A            else
	RJMP _0x4B
_0x4A:
; 0000 053B            PORTD.OUTCLR = 0X20;
	LDI  R30,LOW(32)
	STS  1638,R30
; 0000 053C            if(requ_buffer[10]&0X04)
_0x4B:
	__GETB1MN _requ_buffer,10
	ANDI R30,LOW(0x4)
	BREQ _0x4C
; 0000 053D            PORTD.OUTSET = 0X40;
	LDI  R30,LOW(64)
	STS  1637,R30
; 0000 053E            else
	RJMP _0x4D
_0x4C:
; 0000 053F            PORTD.OUTCLR = 0X40;
	LDI  R30,LOW(64)
	STS  1638,R30
; 0000 0540            if(requ_buffer[10]&0X08)
_0x4D:
	__GETB1MN _requ_buffer,10
	ANDI R30,LOW(0x8)
	BREQ _0x4E
; 0000 0541            PORTD.OUTSET = 0X80;
	LDI  R30,LOW(128)
	STS  1637,R30
; 0000 0542            else
	RJMP _0x4F
_0x4E:
; 0000 0543            PORTD.OUTCLR = 0X80;
	LDI  R30,LOW(128)
	STS  1638,R30
; 0000 0544 
; 0000 0545 
; 0000 0546            for(i=0x01;i<=0x08;i=i*2)
_0x4F:
	__GETWRN 18,19,1
_0x51:
	__CPWRN 18,19,9
	BRGE _0x52
; 0000 0547             {
; 0000 0548            if(requ_buffer[10]&i)
	__GETB2MN _requ_buffer,10
	MOVW R30,R18
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x53
; 0000 0549            PORTD.OUTSET = i*16;
	LDI  R26,LOW(16)
	MULS R18,R26
	MOVW R30,R0
	STS  1637,R30
; 0000 054A            else
	RJMP _0x54
_0x53:
; 0000 054B            PORTD.OUTCLR = i*16;
	LDI  R26,LOW(16)
	MULS R18,R26
	MOVW R30,R0
	STS  1638,R30
; 0000 054C             }
_0x54:
	LSL  R18
	ROL  R19
	RJMP _0x51
_0x52:
; 0000 054D 
; 0000 054E            PORTD.OUT |= ((requ_buffer[10]<<4)&0xF0);
	LDI  R26,LOW(1636)
	LDI  R27,HIGH(1636)
	MOV  R0,R26
	LD   R26,X
	__GETB1MN _requ_buffer,10
	SWAP R30
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	MOV  R26,R0
	ST   X,R30
; 0000 054F //            PORTD.OUT = (0xFF);
; 0000 0550 
; 0000 0551 
; 0000 0552 
; 0000 0553            putchar(0xCC);
	LDI  R26,LOW(204)
	RCALL _putchar
; 0000 0554            ADCA_data = adca_read(0);
	LDI  R26,LOW(0)
	RCALL _adca_read
	MOVW R20,R30
; 0000 0555            send_data[0] = ADCA_data>>8 ;
	__PUTBSR 21,0
; 0000 0556            send_data[1] = ADCA_data ;
	MOVW R30,R28
	ADIW R30,1
	ST   Z,R20
; 0000 0557 
; 0000 0558            ADCA_data = adca_read(1);
	LDI  R26,LOW(1)
	RCALL _adca_read
	MOVW R20,R30
; 0000 0559            send_data[2] = ADCA_data>>8 ;
	__PUTBSR 21,2
; 0000 055A            send_data[3] = ADCA_data ;
	MOVW R30,R28
	ADIW R30,3
	ST   Z,R20
; 0000 055B 
; 0000 055C            ADCA_data = adca_read(2);
	LDI  R26,LOW(2)
	RCALL _adca_read
	MOVW R20,R30
; 0000 055D            send_data[4] = ADCA_data>>8 ;
	__PUTBSR 21,4
; 0000 055E            send_data[5] = ADCA_data ;
	MOVW R30,R28
	ADIW R30,5
	ST   Z,R20
; 0000 055F 
; 0000 0560            ADCA_data = adca_read(3);
	LDI  R26,LOW(3)
	RCALL _adca_read
	MOVW R20,R30
; 0000 0561            send_data[6] = ADCA_data>>8 ;
	__PUTBSR 21,6
; 0000 0562            send_data[7] = ADCA_data ;
	MOVW R30,R28
	ADIW R30,7
	ST   Z,R20
; 0000 0563 
; 0000 0564            ADCA_data = adcb_read(0);
	LDI  R26,LOW(0)
	RCALL _adcb_read
	MOVW R20,R30
; 0000 0565            send_data[8] = ADCA_data>>8 ;
	__PUTBSR 21,8
; 0000 0566            send_data[9] = ADCA_data ;
	MOVW R30,R28
	ADIW R30,9
	ST   Z,R20
; 0000 0567 
; 0000 0568            ADCA_data = adcb_read(1);
	LDI  R26,LOW(1)
	RCALL _adcb_read
	MOVW R20,R30
; 0000 0569            send_data[10] = ADCA_data>>8 ;
	__PUTBSR 21,10
; 0000 056A            send_data[11] = ADCA_data ;
	MOVW R30,R28
	ADIW R30,11
	ST   Z,R20
; 0000 056B            //output ports
; 0000 056C            send_data[12] = ((PORTB.IN&0XF0)>>4);
	LDS  R30,1576
	ANDI R30,LOW(0xF0)
	LDI  R31,0
	CALL __ASRW4
	STD  Y+12,R30
; 0000 056D            send_data[13] = (PORTC.IN&0XF0);
	LDS  R30,1608
	ANDI R30,LOW(0xF0)
	STD  Y+13,R30
; 0000 056E            send_data[13] |= (PORTD.IN&0X0F);
	MOVW R30,R28
	ADIW R30,13
	MOVW R0,R30
	LD   R26,Z
	LDS  R30,1640
	ANDI R30,LOW(0xF)
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
; 0000 056F 
; 0000 0570            for(ai=0;ai<=13;ai++)
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
_0x56:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,14
	BRSH _0x57
; 0000 0571            {
; 0000 0572             putchar(send_data[ai]);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
; 0000 0573            }
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x56
_0x57:
; 0000 0574 
; 0000 0575            putchar(0xDD);
	LDI  R26,LOW(221)
	RCALL _putchar
; 0000 0576               }
; 0000 0577       }
_0x44:
	RJMP _0x41
; 0000 0578 }
_0x58:
	RJMP _0x58
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_requ_buffer:
	.BYTE 0xE
_rx_buffer_usartf0:
	.BYTE 0x40
_rx_rd_index_usartf0:
	.BYTE 0x1
_rx_counter_usartf0:
	.BYTE 0x1
_tx_buffer_usartf0:
	.BYTE 0x40
_tx_wr_index_usartf0:
	.BYTE 0x1
_tx_rd_index_usartf0:
	.BYTE 0x1
_tx_counter_usartf0:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	SUBI R30,LOW(-_requ_buffer)
	SBCI R31,HIGH(-_requ_buffer)
	ST   Z,R16
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	CALL __LSLW3
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	MOVW R26,R16
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x3:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x414D70A4
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
	RET


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
