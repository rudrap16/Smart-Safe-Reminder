################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../source/semihost_hardfault.c \
../source/smart_safe_reminder.c 

S_SRCS += \
../source/Function.s 

C_DEPS += \
./source/semihost_hardfault.d \
./source/smart_safe_reminder.d 

OBJS += \
./source/Function.o \
./source/semihost_hardfault.o \
./source/smart_safe_reminder.o 


# Each subdirectory must supply rules for building sources it contributes
source/%.o: ../source/%.s source/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: MCU Assembler'
	arm-none-eabi-gcc -c -x assembler-with-cpp -D__REDLIB__ -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\board" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\source" -g3 -gdwarf-4 -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -D__REDLIB__ -specs=redlib.specs -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

source/%.o: ../source/%.c source/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -D__REDLIB__ -DCPU_MK66FN2M0VMD18 -DCPU_MK66FN2M0VMD18_cm4 -DSDK_OS_BAREMETAL -DSDK_DEBUGCONSOLE=1 -DCR_INTEGER_PRINTF -DPRINTF_FLOAT_ENABLE=0 -DSERIAL_PORT_TYPE_UART=1 -D__MCUXPRESSO -D__USE_CMSIS -DDEBUG -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\board" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\drivers" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\component\uart" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\device" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\CMSIS" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\component\serial_manager" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\component\lists" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\utilities" -I"C:\Users\kruna\Documents\MCUXpressoIDE_25.6.136\Microprocessor_Project\source" -O0 -fno-common -g3 -gdwarf-4 -Wall -c -ffunction-sections -fdata-sections -fno-builtin -fmerge-constants -fmacro-prefix-map="$(<D)/"= -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -D__REDLIB__ -fstack-usage -specs=redlib.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-source

clean-source:
	-$(RM) ./source/Function.o ./source/semihost_hardfault.d ./source/semihost_hardfault.o ./source/smart_safe_reminder.d ./source/smart_safe_reminder.o

.PHONY: clean-source

