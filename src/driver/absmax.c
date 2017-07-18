/**
* @file absmax.c
* @brief Implementazione delle funzionalità del device driver per il componente @ref absmax.
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
#include "absmax.h"

/**
* @brief Inizializza l'istanza di absmax_t.
*
* @param[inout] instance_ptr è un puntatore ad un'istanza di absmax_t.
*   La struttura dati deve essere preventivamente allocata dal chiamante.
*   Ogni successiva chiamata ad una funzione del driver deve essere fatta
*   fornendo questo puntatore.
* @param[in] base_address è un puntatore all'indirizzo base della periferica.
*
* @return	None.
*
*/
void absmax_init(absmax_t* instance_ptr, uint32_t* base_address)
{
  instance_ptr->isReady = ABSMAX_NOT_READY;

  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);

  // Popola la struttura dati del device con i dati forniti
  instance_ptr->base_address = base_address;

  // Indica che l'istanza è pronta per l'uso, inizializzata senza errori
  instance_ptr->isReady = ABSMAX_READY;
}

/**
* @brief Restituisce lo spiazzamento del massimo all'interno della frequenza doppler.
*
* @param instance_ptr è un puntatore ad un'istanza di absmax_t.
*
* @return Posizione del massimo all'interno della frequenza doppler.
*
*/
uint32_t absmax_get_campione(absmax_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == ABSMAX_READY);

  return gpio_read_mask(instance_ptr->base_address, REG_POSCAMPIONE_OFFSET);
}

/**
* @brief Restituisce la frequenza doppler alla quale appartiene il massimo.
*
* @param instance_ptr è un puntatore ad un'istanza di absmax_t.
*
* @return Intervallo di frequenza doppler del massimo.
*
*/
uint32_t absmax_get_doppler(absmax_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == ABSMAX_READY);

  return gpio_read_mask(instance_ptr->base_address, REG_POSDOPPLER_OFFSET);
}

/**
* @brief Restituisce il satellite al quale appartiene il massimo.
*
* @param instance_ptr è un puntatore ad un'istanza di absmax_t.
*
* @return Identificativo del satellite associato al massimo.
*
*/
uint32_t absmax_get_satellite(absmax_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == ABSMAX_READY);

  return gpio_read_mask(instance_ptr->base_address, REG_POSSATELLITE_OFFSET);
}

/**
* @brief Restituisce il campione massimo.
*
* @param instance_ptr è un puntatore ad un'istanza di absmax_t.
*
* @return Valore complesso del campione massimo (parte immaginaria + parte reale).
*
*/
uint32_t absmax_get_samplemax(absmax_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == ABSMAX_READY);

  return gpio_read_mask(instance_ptr->base_address, REG_SAMPLEMAX_OFFSET);
}

/**
* @brief Restituisce il modulo del campione massimo.
*
* @param instance_ptr è un puntatore ad un'istanza di absmax_t.
*
* @return Modulo del massimo campione.
*
*/
uint32_t absmax_get_max(absmax_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == ABSMAX_READY);

  return gpio_read_mask(instance_ptr->base_address, REG_MAX_OFFSET);
}

/**
* @brief Restituisce lo stato del bit valid_out.
*
* @param instance_ptr è un puntatore ad un'istanza di absmax_t.
*
* @return Maschera di bit avente il bit valid_out nell'LSB.
*
*/
uint32_t absmax_get_valid_out(absmax_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == ABSMAX_READY);

  return (gpio_read_mask(instance_ptr->base_address, ABS_STATUS_REG_OFFSET) & VALID_OUT_MASK);
}

/** @} */
