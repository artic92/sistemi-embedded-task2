/**
* @file signal_generator.c
* @brief Implementazione delle funzionalità del device driver per il componente @ref signal_generator.
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
#include "signal_generator.h"

/**
* @brief Inizializza l'istanza di sgenerator_t.
*
* @param[inout] instance_ptr è un puntatore ad un'istanza di sgenerator_t.
*   La struttura dati deve essere preventivamente allocata dal chiamante.
*   Ogni successiva chiamata ad una funzione del driver deve essere fatta
*   fornendo questo puntatore.
* @param[in] base_address è un puntatore all'indirizzo base della periferica.
*
* @return	None.
*
*/
void sgenerator_init(sgenerator_t* instance_ptr, uint32_t* base_address)
{
  instance_ptr->isReady = SGENERATOR_NOT_READY;

  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);

  // Popola la struttura dati del device con i dati forniti
  instance_ptr->base_address = base_address;

  // Indica che l'istanza è pronta per l'uso, inizializzata senza errori
  instance_ptr->isReady = SGENERATOR_READY;
}

/**
 * @brief Imposta il valore di PINC.
 *
 * @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
 * @param pinc è il valore di PINC da impostare.
 *
 * @return	None.
 *
 * @note
 *  Il valore di PINC deve essere rappresentato su 24 bit.
 */
void sgenerator_setPinc(sgenerator_t* instance_ptr, uint32_t pinc)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  gpio_write_mask(instance_ptr->base_address, REG_PINC_OFFSET, pinc);
}

/**
 * @brief Imposta il valore di POFF.
 *
 * @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
 * @param poff è il valore di POFF da impostare.
 *
 * @return	None.
 *
 * @note
 *  Il valore di POFF deve essere rappresentato su 24 bit.
 */
void sgenerator_setPoff(sgenerator_t* instance_ptr, uint32_t poff)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  gpio_write_mask(instance_ptr->base_address, REG_POFF_OFFSET, poff);
}

/**
* @brief Restituisce il valore di PINC.
*
* @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
*
* @return	Valore di PINC.
*
* @note
*   Il valore di PINC è rappresentato su 24 bit.
*/
uint32_t sgenerator_getPinc(sgenerator_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  return gpio_read_mask(instance_ptr->base_address, REG_PINC_OFFSET);
}

/**
* @brief Restituisce il valore di POFF.
*
* @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
*
* @return	Valore di POFF.
*
* @note
*   Il valore di POFF è rappresentato su 24 bit.
*/
uint32_t sgenerator_getPoff(sgenerator_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  return gpio_read_mask(instance_ptr->base_address, REG_POFF_OFFSET);
}

/**
 * @brief Avvia la generazione dei campioni.
 *
 * @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
 *
 * @return	None.
 */
void sgenerator_start(sgenerator_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  sgenerator_set_valid_in(instance_ptr);
  sgenerator_reset_valid_in(instance_ptr);
}

/**
 * @brief Setta il bit valid_in.
 *
 * @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
 *
 * @note
 *  Questa è una funzione di utilità per sgenerator_start().
 *  Non utilizzare direttamente questa funzione, utilizzare sgenerator_start().
 *  @see sgenerator_start()
 */
void sgenerator_set_valid_in(sgenerator_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  gpio_write_mask(instance_ptr->base_address, REG_VALID_IN_OFFSET, gpio_read_mask(instance_ptr->base_address, REG_VALID_IN_OFFSET) | DONE_MASK);
}

/**
 * @brief Resetta il bit valid_in.
 *
 * @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
 *
 * @note
 *  Questa è una funzione di utilità per sgenerator_start().
 *  Non utilizzare direttamente questa funzione, utilizzare sgenerator_start().
 *  @see sgenerator_start()
 */
void sgenerator_reset_valid_in(sgenerator_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  gpio_write_mask(instance_ptr->base_address, REG_VALID_IN_OFFSET, gpio_read_mask(instance_ptr->base_address, REG_VALID_IN_OFFSET)& ~DONE_MASK);
}

/**
* @brief Restituisce lo stato del bit done.
*
* @param instance_ptr è un puntatore ad un'istanza di sgenerator_t.
*
* @return Maschea di bit con il bit done nell'LSB.
*
*/
uint32_t sgenerator_get_done(sgenerator_t* instance_ptr)
{
  // Verifica che il puntatore alla struttura dati non sia nullo
  assert(instance_ptr != NULL);
  // Verifica che il dispositivo è pronto e funzionante
  assert(instance_ptr->isReady == SGENERATOR_READY);

  return (gpio_read_mask(instance_ptr->base_address, SGEN_STATUS_REG_OFFSET) & DONE_MASK);
}

/** @} */
