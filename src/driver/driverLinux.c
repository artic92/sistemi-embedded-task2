/**
* @file driverLinux.c
* @brief Applicazione Linux dimostrativa
* @author: Antonio Riccio, Andrea Scognamiglio, Stefano Sorrentino
* @copyright
* Copyright 2017 Antonio Riccio <antonio.riccio.27@gmail.com>, <antonio.riccio9@studenti.unina.it>.
* This program is free software; you can redistribute it and/or modify it under the terms of the
* GNU General Public License as published by the
* Free Software Foundation; either version 3 of the License, or any later version.
* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY
* or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
* You should have received a copy of the GNU General Public License along with this program;
* if not, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
*
*/
/***************************** Include Files ********************************/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <sys/mman.h>

#include "signal_generator.h"
#include "absmax.h"

#define DEBUG
#define MEM_AREA_SIZE 0x10000
#define DOPPLERS  		11
#define SATELLITI 		2

int fd_sgenerator, fd_absmax;
char *uiod_sgen, *uiod_absmax;
void *sgen_base_addr, *absmax_base_addr;

int doppler_count = 0;
int dopplers[DOPPLERS] = {-3250, -2625, -2000, -1375, -750, -125, 500, 1125, 1750, 2375, 3000};
uint32_t pinc[DOPPLERS] = {0x00FFF597, 0x00FFF797, 0x00FFF998, 0x00FFFB98, 0x00FFFD99, 0x00FFFF99, 0x0000019A, 0x0000039B, 0x0000059B, 0x0000079C, 0x0000099C};
uint32_t poff[DOPPLERS] = {0x00A00000, 0x00500000, 0x00000000, 0x00B00000, 0x00600000, 0x00100000, 0x00C00000, 0x00700000, 0x00200000, 0x00D00000, 0x00800000};

sgenerator_t sig_gen;
absmax_t abs_max;

/************************** Function Prototypes *****************************/
void setup(void);
void loop(void);

int main(int argc, char *argv[])
{
	int i, iterazioni = DOPPLERS*SATELLITI;
	uiod_sgen = "/dev/uio1";
	uiod_absmax = "/dev/uio0";

	printf("******** Applicazione dimostrativa del TASK 2 per sistemi embedded ********\n");
	printf("******** Per terminare l'applicazione premi CTRL+C ************************\n");

	setup();
  for(i = 0; i < iterazioni; i++) loop();

	printf("In attesa che il blocco compute_max termini...\n");
 	while(absmax_get_valid_out(&abs_max) != 1);

	printf("\nMASSIMO trovato!\n");
	printf("Campione: %X\n", 	absmax_get_samplemax(&abs_max));
	printf("Modulo: %X\n", absmax_get_max(&abs_max));

	printf("\nCoordinate del MASSIMO:\n");
	printf("Spiazzamento nella doppler: %u\n", absmax_get_campione(&abs_max));
	printf("Frequenza doppler: %u\n", absmax_get_doppler(&abs_max));
 	printf("Satellite: %u\n", absmax_get_satellite(&abs_max));

	// Unmapping degli indirizzi fisici della periferiche con quelli
	// virtuali del processo in esecuzione
	munmap(sgen_base_addr, MEM_AREA_SIZE);
	munmap(absmax_base_addr, MEM_AREA_SIZE);

	// Chiusura dei file
	close(fd_sgenerator);
	close(fd_absmax);
	return 0;
}

/**
* @brief Configura l'hardware.
*
* @details Apre i descrittori dei device file relativi alle periferiche
*		controllate dal modulo UIO, mappa gli indirizzi fisici della periferica con
*		gli indirizzi virtuali del processo e Inizializza opportunamente le periferiche.
*/
void setup(void)
{
	#ifdef DEBUG
	printf("[DEBUG] Apertura dei device files...\n");
	#endif

	// Apre il device file relativo a signal_generator
	fd_sgenerator = open(uiod_sgen, O_RDWR);
	if (fd_sgenerator < 1) {
		printf("Apertura device file (%s) non riuscita! Errore: %s\n", uiod_sgen, strerror(errno));
		exit(EXIT_FAILURE);
	}

	// Apre il device file relativo a absmax
	fd_absmax = open(uiod_absmax, O_RDWR);
	if (fd_absmax < 1) {
		printf("Apertura device file (%s) non riuscita! Errore: %s\n", uiod_absmax, strerror(errno));
		close(fd_sgenerator);
		exit(EXIT_FAILURE);
	}

	#ifdef DEBUG
	printf("[DEBUG] Mapping degli indirizzi tra indirizzi fisici e virtuali...\n");
	#endif

	// Mappa gli indirizzi fisici della periferiche con quelli virtuali del processo
	// NOTA: questa funzione restituisce indirizzi virtuali DIVERSI a ciascun processo
	//			 che vuole far uso dei medesimi indirizzi fisici. Questo è possibile solo
	//			 se il flag MAP_SHARED è settato.
	sgen_base_addr = mmap(NULL, MEM_AREA_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd_sgenerator, 0);
	if(sgen_base_addr == MAP_FAILED){
		printf("Mapping degli indirizzi per il descrittore %s non riuscito. Errore: %s\n", uiod_sgen, strerror(errno));
		close(fd_sgenerator);
		close(fd_absmax);
		exit(EXIT_FAILURE);
	}

	absmax_base_addr = mmap(NULL, MEM_AREA_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd_absmax, 0);
	if(absmax_base_addr == MAP_FAILED){
		printf("Mapping degli indirizzi per il descrittore %s non riuscito. Errore: %s\n", uiod_absmax, strerror(errno));
		munmap(sgen_base_addr, MEM_AREA_SIZE);
		close(fd_sgenerator);
		close(fd_absmax);
		exit(EXIT_FAILURE);
	}

	#ifdef DEBUG
	printf("[DEBUG] Configurazione dei device hardware...\n");
	#endif

	// Configurazione signal_generator
	sgenerator_init(&sig_gen, (uint32_t*)sgen_base_addr);

	// Configurazione absmax
 	absmax_init(&abs_max, (uint32_t*)absmax_base_addr);

	#ifdef DEBUG
	printf("[DEBUG] Configurazione completata!\n");
	#endif
}

void loop(void)
{
	printf("Generazione campioni per la DOPPLER %u (%i Hz)\n", doppler_count+1, dopplers[doppler_count]);

	printf("Valore di PINC: %X\n", pinc[doppler_count]);
  sgenerator_setPinc(&sig_gen, pinc[doppler_count]);

	printf("Valore di POFF: %X\n", poff[doppler_count]);
  sgenerator_setPoff(&sig_gen, poff[doppler_count]);

  sgenerator_start(&sig_gen);

	printf("In attesa che il blocco signal_generator termini...\n");
  while(sgenerator_get_done(&sig_gen) != 1);
	
	printf("Generazione campioni TERMINATA per la DOPPLER %u\n\n", doppler_count+1);
	doppler_count++;
}
/** @} */
