#' chopepi
#'
#' Paquete para trocear episodios segun varias escalas temporales (\code{chop}) y
#' posteriormente combinarlos (\code{combine2c}). \code{chop} y \code{combine2c}
#' almacenan los subepisodios como una lista asociada a la clave identificadora
#' de episodio \emph{kid}. \code{melpEpi} pasa este pseudo-formato ancho a un
#' formato corto (cada subepisodios, generado por el troceado es una nueva fila).
#' Por ultimo la función \code{addCXst} añade los estados y transiones asociado
#' a cada subepisodios recuperado los Current y Exit states de la tabla de
#' episodios original
#'
#'
#' @docType package
#' @name chopepi
#' @import data.table
#' @importFrom utils head tail




