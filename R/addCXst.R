
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
#'
#' @return data.table de subepisodios ampliada con dos nuevos campos
#'         Cst (Current Status) u Xst (exit status) tomado dela tabla
#'         original 'epi.original'
#'
#' @examples
#' \donttest{
#'     start.times <- c(16,21,32) ;  durations <- c(12.5,19.4, 7.3) ;  breaks <- seq(10,50, by=5)
#'     start.times2 <- c(1997,2005.2,2007) ;                           breaks2 <- seq(1990,2020, by=5)
#'     DT <- data.table::data.table(id = 1:length(start.times),
#'                 start.times=start.times,
#'                 start.times2=start.times2,
#'                 durations = durations,
#'                 st.start=c(1L,2L,1L),
#'                 st.end=c(3L,2L,3L)
#'                 )
#'
#'    rm(start.times,start.times2,durations)
#'    chop (start.times,  durations, breaks , timedim = 'edad'   , kid=id, data = DT) -> epi.seq1
#'    chop (start.times2, durations, breaks2, timedim = 'periodo', kid=id, data = DT) -> epi.seq2
#'    combine2c (epi.seq1,epi.seq2) -> epi.1y2
#'    meltEpi(epi.1y2) -> epi.melt
#'    head (epi.melt)

#'   addCXst (epi.melt =  epi.melt,
#'           epi.original = DT,
#'           Cst= 'st.start',  Xst='st.end',
#'           id.original = 'id') -> epi.melt.CXst
#'   head(epi.melt.CXst)
#'   }

addCXst <- function (epi.melt,epi.original,
                       Cst= 'Cst',  Xst='Xst',
                      id.original = 'kid') {
  rm(list = c(":=",".N"))
  data.table::merge.data.table(epi.melt,epi.original[,c(id.original,Cst,Xst), with=F],
               by.y= id.original, by.x='kid') -> epi.melt.st
  data.table::setnames(epi.melt.st,c(Cst,Xst),c('Cst','Xst'))

  epi.melt.st[,Xst:=c(Cst[-.N],Xst[.N]),.(kid)]

  return(epi.melt.st)

}

