
### ==================================================================================================
#' meltEpi
#'
#' Toma una tabla de episodios  (durations) preprocesado por \code{chop} y que
#' cada fila contiene una lista con el vector de subepisodio troceado por una o
#' mas escalas temporales, y genera un registro individual por cada uno de los
#' subepisodio contenidos en el episodio.
#'
#' @param epi.breaks objeto episodio particionado, al menos por una
#'     dimensión temporal
#'
#' @param type tipo de etiqueta asignada a cada banda dimensional
#'
#' @param dec.precision escala de precion para las comparaciones
#'
#' @export
#'
#' @return un data.table donde cada registro de episodio se ha divido en tamtos
#'         subepisodios como elemetos haya en el vectos de troceado generado
#'         prevaimente por la combinacion de funciones \code{chop} y
#'         \code{combine2c}
#'
#' @examples
#'
#' \donttest{
#' ## Trocea una tabla de episodios en 3 escalas termporales distintas
#'   start.times <- c(16,21,32)
#'   durations <- c(12.5,19.4, 7.3)      ; breaks <- seq(10,50, by=5)
#'   start.times2 <- c(1997,2005.2,2007) ; breaks2 <- seq(1990,2020, by=5)

#'   chop (start.times,  durations,  breaks,   timedim = 'edad' )   -> epi.seq1
#'   chop (start.times2, durations,  breaks2 , timedim = 'periodo') -> epi.seq2
#'
#' ## Combina las dos escalas en dos pasos ...
#'   combine2c (epi.seq1,epi.seq2) -> epi.1y2
#'   meltEpi(epi.1y2) -> epi.melt
#' }
#'
meltEpi <- function (epi.breaks, type = c("factor", "left", "middle", "right","integer"), dec.precision=3 ) {

  attributes(epi.breaks) -> att ; a.nam <- names(att)[grepl('^breaks\\.',names(att))]
  att[a.nam] -> att
  v.nam <- sapply(strsplit(a.nam, '^breaks\\.'),function (e) e[2])
  d.nam <- names(epi.breaks) [ grepl('^durations\\.' ,names(epi.breaks))]
  epi.breaks[,{ dura <- get(d.nam)[[1]] ;
               change.bands <-c(0,cumsum(dura)[-length(dura)]) ;
               kk <- lapply(.SD, function (e) { e[[1]] + change.bands } )
               kk$durations=dura
               kk},kid ,.SDcols=v.nam] -> epi.melt
  v.band.nm <- paste0('band.',v.nam)
  if ( ! is.null(type)) epi.melt[,c(v.band.nm):= .(NA) ]

  # hereda los atributos de epi.breaks
  for (i in a.nam) {
    attr(epi.melt,i) <- att[[i]]
  }
  # names(attributes(epi.melt))

  #---------------------------------------------------

  # añade etiquetas a las bandas temporo-dimensionales
  # paste de codigo tomado  de funcion "timeband" de Martyn Plummer"
  # names(attributes(epi.melt))  ; i <- 'edad'
  if (! is.null(type)) {
     type <- type[1]
     for (i in v.nam) {
      breaks  <- attr(epi.melt,paste0('breaks.',i))
      band    <- findInterval(round(get(i,epi.melt),dec.precision),
                              round( breaks,dec.precision), left.open=FALSE )
      if (!type=='integer') {

        b.max <- ifelse(is.integer(breaks ), .Machine$integer.max, Inf)

        I1 <- c(-b.max, breaks)  ## añadir Inf pasa vector de enteros a númerico
        I2 <- c(breaks, b.max)
        labels <- switch(type, factor = paste("[", I1, ",", I2, ")",
                                            sep = ""), left = I1, right = I2, middle = (I1 + I2)/2)
        if (type == "factor") {
           band <- factor(band, levels = 0:length(breaks), labels = labels)
        } else  {
           band <- labels[band + 1]
        }
      }
      epi.melt[,c(paste0('band.',i)):=list(band)]
     }
  }

  # str(epi.melt)

  # termina ----
  return(epi.melt)
}
