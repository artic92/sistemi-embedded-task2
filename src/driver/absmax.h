/**
* @file absmax.h
* @brief Definizioni di funzioni per il driver del componente che calcola il massimo.
* @anchor absmax
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
#ifndef ABSMAX_H
#define ABSMAX_H

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
#define REG_SAMPLEMAX_OFFSET 	   0
#define REG_POSCAMPIONE_OFFSET 	 4
#define REG_POSDOPPLER_OFFSET	   8
#define REG_POSSATELLITE_OFFSET	12
#define REG_MAX_OFFSET          16
#define ABS_STATUS_REG_OFFSET   20
/* @} */

/**
* @brief Maschera che indica la posizione del bit valid_out nel registro di stato
*/
#define VALID_OUT_MASK          0x00000001

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
  ABSMAX_READY,                           /**< Componente pronto e configurato correttamente */
  ABSMAX_NOT_READY                        /**< Componente non pronto e non configurato correttamente */
} absmax_ready;

/**
 * @brief Struttura dati del driver di absmax.
 *
 * @details L'utilizzatore deve allocare una struttura di questo tipo per ogni
 * 		periferica che intende gestire. Questo poichè le funzioni nell'API
 * 		richiedono un puntatore ad una variabile di questo tipo.
 *
 */
typedef struct {
	uint32_t* base_address;	 								/**< Indirizzo base della periferica */
	absmax_ready isReady;		         				/**< Periferica inizializzata e pronta */
} absmax_t;

/************************** Function Prototypes *****************************/
/**
 * @name Funzioni di inizializazzione
 */
void absmax_init(absmax_t* instance_ptr, uint32_t *base_address);

/**
 * @name Funzioni per le operazioni di I/O
 * @{
 */
uint32_t absmax_get_campione(absmax_t* instance_ptr);
uint32_t absmax_get_doppler(absmax_t* instance_ptr);
uint32_t absmax_get_satellite(absmax_t* instance_ptr);
uint32_t absmax_get_samplemax(absmax_t* instance_ptr);
uint32_t absmax_get_max(absmax_t* instance_ptr);
/* @} */

/**
 * @name Funzioni per la gestione dello stato
 * @{
 */
uint32_t absmax_get_valid_out(absmax_t* instance_ptr);
/* @} */

#endif /* SRC_ABSMAX_H_ */
/** @} */
