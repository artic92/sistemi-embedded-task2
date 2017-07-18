/**
* @file main.c
* @brief Applicazione dimostrativa
* @example driverLinux.c
* @author: Antonio Riccio, Andrea Scognamiglio, Stefano Sorrentino
* @copyright
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
*/
#include "xparameters.h"
#include "gpio_ll.h"
#include "signal_generator.h"
#include "absmax.h"

/**
 * @name Parametri di configurazione del driver
 * @note Questi parametri devono essere IDENTICI ai valori usati per instanziare il componente hardware
 * @{
 */
#define DOPPLERS  11
#define SATELLITI 2
/* @} */

int doppler_count = 0;
uint32_t pinc[DOPPLERS] = {0x00FFF597, 0x00FFF797, 0x00FFF998, 0x00FFFB98, 0x00FFFD99, 0x00FFFF99, 0x0000019A, 0x0000039B, 0x0000059B, 0x0000079C, 0x0000099C};
uint32_t poff[DOPPLERS] = {0x00000000, 0x00000000, 0x00000FFF, 0x00FFF000, 0x000F0F0F, 0x00F0F0F0, 0x00FF0000, 0x0000FF00, 0x000000DC, 0x00003400, 0x00220000};

sgenerator_t sig_gen;
absmax_t abs_max;

void setup(void);
void loop(void);

/**
*
* @brief Applicazione di testing per le funzionalità delle periferiche.
*
* @details Questa applicazione fa generare al @ref signal_generator dei campioni in
*    un ciclo di DOPPLERS*SATELLITI iterazioni. Dopodichè legge il valore del massimo
*    e le sue coordinate dal blocco @ref absmax.
*/
int main()
{
  int i, iterazioni = DOPPLERS*SATELLITI;

  setup();
  for(i = 0; i < iterazioni; i++) loop();

  // Attende che il blocco @ref absmax abbia terminato
  while(absmax_get_valid_out(&abs_max) != 1);

  // Preleva i dati relativi al massimo
  uint32_t campione = absmax_get_campione(&abs_max);
  uint32_t doppler = absmax_get_doppler(&abs_max);
  uint32_t satellite = absmax_get_satellite(&abs_max);
  uint32_t max = absmax_get_max(&abs_max);
  uint32_t samplemax = absmax_get_samplemax(&abs_max);

  return 0;
}

/**
* @brief Setup dell'hardware.
*
* @details Inizializza le strutture dati delle periferiche con i rispettivi indirizzi base.
*/
void setup()
{
  sgenerator_init(&sig_gen, (uint32_t*)XPAR_SIGNAL_GENERATOR_0_S00_AXI_BASEADDR);
  absmax_init(&abs_max, (uint32_t*)XPAR_ABSMAX_0_S00_AXI_BASEADDR);
}

/**
 * @brief Main loop.
 *
 * @details Setta i valori di PINC e POFF con dei valori di esempio e fa partire
 *   il @ref signal_generator.
 */
void loop()
{
  // Setta i valori di PINC e POFF
  sgenerator_setPinc(&sig_gen, pinc[doppler_count % DOPPLERS]);
  sgenerator_setPoff(&sig_gen, poff[doppler_count % DOPPLERS]);

  // Avvia il signal_generator
  sgenerator_start(&sig_gen);

  // Aspetta che il signal_generator abbia terminato
  while(sgenerator_get_done(&sig_gen) != 1);

  // Incrementa il contatore delle doppler
  doppler_count++;
}
