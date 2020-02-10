
### ==================================================================================================
#' combine2c
#'
#' Combina dos objeto del tipo "secuencia de subepisodios"  producido sobre una
#' misma tabla madre de episodios producido por la función  por
#' \code{chopepi::chop}  pero particionado en dos dimensiones
#' temporales distintas. Ejemplo años cumplidos y anualidades
#'
#' @param epi.seq1 secuencia de subepisodio de un episodio dado
#'     definido en una dimension temporal dada (ejemplo edad)
#'
#' @param epi.seq2 secuencia de subepisodio del mimos episodio anterio
#'     pero definido en segunda dimension temporal dada (ejemplo
#'     tiempo calendario)
#'
#' @param dec.precision maxima precion decimal para comparaciones
#'     puntuales
#'
#' @export
#'
#' @return data,table con los registros inteseccion de las tabla de episodios y
#'         y una nueva variable \emph{durations.#...} con la intesercion de los
#'         subepisodios en cada una de las dos escala temporales de los
#'         ficheros fuentes.
#'
#' @examples
#' \donttest{
#' epi.original <- data.table::data.table(
#'  kid = 1:3 ,
#'  start.times1  = c(16,21,32)     ,
#'  durations  = c(12.5,19.4, 7.3) ,
#'  start.times2 = c(1997,2005.2,2007),
#'  Cst = c(0,0,0),
#'  Xst = c(1,1,1)
#'  )
#'
#' chop (start.times =  start.times1,
#'      durations   = durations,
#'      breaks = seq(10,50, by=5),
#'      timedim = 'edad', data = epi.original)  -> epi.seq1
#'
#' chop (start.times = start.times2,
#'      durations    = durations,
#'      breaks       = seq(10,50, by=5),
#'      timedim      = 'edad', data = epi.original)  -> epi.seq2
#'
#' combine2c (epi.seq1,epi.seq2, dec.precision = 2) -> epi.1y2
#' names (epi.1y2)
#'
#' }
combine2c <- function(epi.seq1,epi.seq2, dec.precision=3) {
  data.table::merge.data.table(epi.seq1,epi.seq2,by='kid') -> kk
  xt1 <-  names(epi.seq1)[grepl('^durations\\.', names(epi.seq1) )]
  xt2 <-  names(epi.seq2)[grepl('^durations\\.', names(epi.seq2) )]
  t1 <- strsplit(xt1,'durations\\.')[[1]][2]
  t2 <- strsplit(xt2,'durations\\.')[[1]][2]
  new.comb<-paste0('durations.',t1,'.',t2)

  kk [,c(new.comb):= mapply( function(x,y) {
    c( min(c(x[1],y[1])) ,
                                                    diff(sort ( union(round(cumsum(x),dec.precision),
                                                                      round(cumsum(y),dec.precision) ))))},
                                get(xt1),get(xt2))   ]
  # elimina particiones en escalas antiguas
  kk[,c(xt1,xt2):=list(NULL,NULL)]
  # Añade atributos puntos de corte
  attributes(epi.seq1) -> att1 ; atn1 <- names(att1)[grepl('^breaks\\.',names(att1))]
  attributes(epi.seq2) -> att2 ; atn2 <- names(att2)[grepl('^breaks\\.',names(att2))]


  atn <- c(atn1,atn2)             # pueden existir más de un atributo corte dimensional por objeto
  att <- c(att1[atn1],att2[atn2]) #

  for (i in atn) {
    attr(kk,i) <- att[[i]]
  }

  return(kk)
}

# combine2c (epi.seq1,epi.seq2) -> epi.1y2 names ( attributes(epi.1y2) )

