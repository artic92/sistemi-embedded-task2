/**
* @file signal_generator.h
* @brief Definizioni di funzioni per il driver del generatore di segnali periodici.
* @anchor signal_generator
* @author: Antonio Riccio, Andrea Scognamiglio, Stefano Sorrentino
* @copyright
* Copyright 2017 Antonio Riccio <antonio.riccio.27@gmail.com>, <antonio.riccio9@studenti.unina.it>.
* This program is free software; you can redistribute it and/or modify it under the terms of the
* GNU General Public License as published by the
* Free Software Foundation; either version 3 of the License, or any later version.
* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
* even the implied warranty of MERCHANTABILITY
* or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
* You should have received a copy of the GNU General Public License along with this program; if not,
* write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
*
*/
/*****************************************************************************/
#ifndef SIGNAL_GENERATOR_H
#define SIGNAL_GENERATOR_H

/***************************** Include Files ********************************/
#include <assert.h>
#include <inttypes.h>
#include <stddef.h>
#include "gpio_ll.h"

/**
 * @name Registri
 * @brief Spiazzamenti da utilizzare per l'accesso ai registri della periferica
 * @{
 */
#define REG_POFF_OFFSET 	       0
#define REG_PINC_OFFSET 	       4
#define REG_VALID_IN_OFFSET	     8
#define SGEN_STATUS_REG_OFFSET  12
/* @} */

/**
* @brief Maschera che indica la posizione del bit done nel registro di stato
*/
#define DONE_MASK	              0x00000001

/**************************** Type Definitions ******************************/
/**
 * @brief Enumerazione che indica se il dispositivo è configurato e pronto.
 *
 * Questa enumerazione viene utilizzata dalla funzione init per indicare l'esito
 * dell'operazione di configurazione. Viene utiilizata dagli assert per eseguire
 * controlli preliminari prima di effettuare operazioni sulla periferica.
 *
 */
typedef enum
{
  SGENERATOR_READY,                     /**< Componente pronto e configurato correttamente */
  SGENERATOR_NOT_READY                  /**< Componente non pronto e non configurato correttamente */
} sgen_ready;

typedef struct {
	uint32_t* base_address;	 							/**< Indirizzo base della periferica */
	sgen_ready isReady;		         				/**< Periferica inizializzata e pronta */
} sgenerator_t;

/************************** Function Prototypes *****************************/
/**
 * @name Funzioni di inizializazzione
 */
void sgenerator_init(sgenerator_t* instance_ptr, uint32_t *base_address);

/**
 * @name Funzioni per le operazioni di I/O
 * @{
 */
void sgenerator_setPinc(sgenerator_t* instance_ptr, uint32_t pinc);
void sgenerator_setPoff(sgenerator_t* instance_ptr, uint32_t poff);
uint32_t sgenerator_getPinc(sgenerator_t* instance_ptr);
uint32_t sgenerator_getPoff(sgenerator_t* instance_ptr);
/* @} */

/**
 * @name Funzioni di controllo
 * @{
 */
void sgenerator_start(sgenerator_t* instance_ptr);
void sgenerator_set_valid_in(sgenerator_t* instance_ptr);
void sgenerator_reset_valid_in(sgenerator_t* instance_ptr);
uint32_t sgenerator_get_done(sgenerator_t* instance_ptr);
/* @} */

#endif /* SRC_SIGNAL_GENERATOR_H_ */
/** @} */
