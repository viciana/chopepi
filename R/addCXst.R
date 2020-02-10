
### ==================================================================================================

#' addCXst
#'
#' Añade informacion sobre estado actual (al comienzo del episodio:
#' Cst) y estado a la salida de episodio (Xst) a los subepisodios
#' particionados, heredados de otra data.table con la la inforamacion
#' de Cst y Xst de episodios originales no particonados pero
#' identificados por clave de episodio
#'
#' Cada fila de id.original es un episodios con estados constante =
#' 'Cst", al terminar el episodio se produce,o no, una transición de estados a 'Xst'
#'
#' @param epi.melt    tabla  con secuencia de episodios generada por meltEpi con clave "kid"
#'                    para enlazar con episodio originales
#'
#' @param epi.original tabla con informacion de episodio originales (campo ID, Cst y Xst)
#'
#' @param id.original  cadena de caracter con nombre de columna  con clave identificadora
#'                     de episodio
#'
#' @param Cst vector con la información del estado actual
#'
#' @param Xst vector con la información del  estados de salida
#'
#' @export
#'
#' @import data.table
#'
#' @return data.table de subepisodios ampliada con dos nuevos campos
#'         Cst (Current Status) u Xst (exit status) tomado dela tabla
#'         original 'epi.original'
#'
#' @examples
#' \donttest{
#' epi.original <- data.table::data.table(
#'  kid = 1:3 ,
#'  start.times  = c(16,21,32)     ,
#'  durations  = c(12.5,19.4, 7.3) ,
#'  Cst = c(0,0,0),
#'  Xst = c(1,1,1)
#'  )
#'
#' chop (start.times =  start.times,
#'      durations   = durations,
#'      breaks = seq(10,50, by=5),
#'      timedim = 'edad', data = epi.original)  -> epi.seq
#'
#' meltEpi(epi.seq) -> epi.sub
#'
#' addCXst(epi.sub, epi.original,
#'           Cst= 'Cst',  Xst='Xst',
#'           id.original = 'kid') -> epi.sub2
#' epi.sub2
#'   }

addCXst <- function (epi.melt,epi.original,
                       Cst= 'Cst',  Xst='Xst',
                      id.original = 'kid') {
  # rm(list = c(":=",".N"))
  data.table::merge.data.table(epi.melt,epi.original[,c(id.original,Cst,Xst), with=F],
               by.y= id.original, by.x='kid') -> epi.melt.st
  data.table::setnames(epi.melt.st,c(Cst,Xst),c('Cst','Xst'))

  epi.melt.st[,Xst:=c(Cst[-.N],Xst[.N]),.(kid)]

  return(epi.melt.st)

}

