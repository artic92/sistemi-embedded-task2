OBJECTS=driverLinux.o signal_generator.o absmax.o gpio_ll.o
OPTIONS=-c

all: app

app: $(OBJECTS)
	gcc -o $@ $(OBJECTS)

driverLinux.o: driverLinux.c signal_generator.h absmax.h
	gcc $(OPTIONS) driverLinux.c

signal_generator.o: gpio_ll.h signal_generator.h signal_generator.c
	gcc $(OPTIONS) signal_generator.c

absmax.o: gpio_ll.h absmax.h absmax.c
	gcc $(OPTIONS) absmax.c

gpio_ll.o: gpio_ll.h gpio_ll.c
	gcc $(OPTIONS) gpio_ll.c

clean:
	rm *.o app
