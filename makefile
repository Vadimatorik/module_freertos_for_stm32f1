ifndef MODULE_FREERTOS_FOR_STM32F1_OPTIMIZATION
	MODULE_FREERTOS_FOR_STM32F1_OPTIMIZATION = -g3 -O0
endif

# FreeRTOS.h должен обязательно идти первым! 
MODULE_FREERTOS_FOR_STM32F1_H_FILE				:= module_freertos_for_stm32f1/FreeRTOS.h
MODULE_FREERTOS_FOR_STM32F1_H_FILE				+= $(wildcard module_freertos_for_stm32f1/include/*.h)

# Директории, в которых лежат файлы FreeRTOS.
MODULE_FREERTOS_FOR_STM32F1_DIR					:= module_freertos_for_stm32f1
MODULE_FREERTOS_FOR_STM32F1_DIR					+= module_freertos_for_stm32f1/include

# Подставляем перед каждым путем директории префикс -I.
MODULE_FREERTOS_FOR_STM32F1_PATH				:= $(addprefix -I, $(MODULE_FREERTOS_FOR_STM32F1_DIR))

# Получаем список .c файлов ( путь + файл.c ).
MODULE_FREERTOS_FOR_STM32F1_C_FILE				:= $(wildcard module_freertos_for_stm32f1/*.c)

# Получаем список .o файлов ( путь + файл.o ).
# Сначала прибавляем префикс ( чтобы все .o лежали в отдельной директории
# с сохранением иерархии.
MODULE_FREERTOS_FOR_STM32F1_OBJ_FILE			:= $(addprefix build/obj/, $(MODULE_FREERTOS_FOR_STM32F1_C_FILE))
# Затем меняем у всех .c на .o.
MODULE_FREERTOS_FOR_STM32F1_OBJ_FILE			:= $(patsubst %.c, %.o, $(MODULE_FREERTOS_FOR_STM32F1_OBJ_FILE))
	
MODULE_FREERTOS_FOR_STM32F1_INCLUDE_FILE		:= -include"./module_freertos_for_stm32f1/include/StackMacros.h"

# Сборка FreeRTOS.
# $< - текущий .c файл (зависемость).
# $@ - текущая цель (создаваемый .o файл).
# $(dir путь) - создает папки для того, чтобы путь файла существовал.
build/obj/module_freertos_for_stm32f1/%.o:	module_freertos_for_stm32f1/%.c 
	@echo [CC] $<
	@mkdir -p $(dir $@)
	@$(CC) $(C_FLAGS) $(MODULE_FREERTOS_FOR_STM32F1_PATH) $(USER_CFG_PATH) $(MODULE_FREERTOS_FOR_STM32F1_INCLUDE_FILE) $(MODULE_FREERTOS_FOR_STM32F1_OPTIMIZATION) -c $< -o $@

# Добавляем к общим переменным проекта.
PROJECT_PATH			+= $(MODULE_FREERTOS_FOR_STM32F1_PATH)
PROJECT_OBJ_FILE		+= $(MODULE_FREERTOS_FOR_STM32F1_OBJ_FILE)
