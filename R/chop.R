
### =======================================================================
#' chop
#'
#' \code{chop} trocea la duración de un \emph{episodio}, dado unos
#' puntos de corte, en una determinada escala de tiempo (edad,
#' calendario o duración desde un evento dado..)
#'
#' @section Definiciones:
#'
#' Un episodio es una intervalo temporal con una duración dada. Esta
#' fijado en su origen a un instante termporal concreto. Un episodio
#' tienen principio y fin (esta temporamente datado). Un episodio
#' puede estar censurado por la derecha a partir de una determinada
#' fecha termina su observación. Para la ejecución de esta esta
#' función es indistinto que el cominzo o fin del episodio sea por una
#' transición entre estados o por censura.
#'
#'
#'
#' @param start.times Vector con los puntos temporales (tiempos de
#'     comienzo) de inicio de cada episodio
#'
#' @param durations Vector con las duraciones (en unidades de tiempo)
#'     de cada episodio. El instante de de terminación de cada
#'     episodio es start.times + durations
#'
#' @param breaks Vector con los puntos de corte (chop) en la dimensión
#'     temporal utilizada.  (usa la funcion "cut" a la que se le
#'     pueden pasar el parametros "right")
#'
#' @param kid clave primaria de episodio
#'
#' @param timedim nombre de la dimension
#'
#' @param data data.frame con los episodios
#'
#' @return un objeto del tipo data.table donde cada fila contiene tres
#'     variables: (1) una clave de identificacion de episodio "kid",
#'     (2) una variable con el nombre de la dimension temporal con el
#'     punto de inicio del episodio, (3) un vector con las duraciones
#'     de los sub-episodios en los que se ha particionado el episodio
#'     origina segun la regla dada por los puntos de corte. El
#'     attributo breaks.<dimension> contiene la regla utilizada
#'
#' @exportt
#'
#' @examples
#' \donttest{
#'     start.times <- c(16,21,32) ;  durations <- c(12.5,19.4, 7.3) ; breaks <- seq(10,50, by=5)
#'     chop (start.times, durations,  breaks ) -> kk ; kk
#'     # comprueba
#'     cbind(sapply(kk$epi.durations, sum) , durations)
#'     # borra termporales
#'     rm(start.times,durations,breaks)
#'     }

chop <- function (start.times, durations,  breaks,
                         kid= 1:length(start.times), timedim='Time', data = NULL)
  {
  if (!missing(data)) {
    if (!missing(start.times)) start.times <- eval(substitute(start.times), data, parent.frame())
    if (!missing(durations)) durations <- eval(substitute(durations), data, parent.frame())
    if (!missing(breaks)) breaks <- eval(substitute(breaks), data, parent.frame())
    if (!missing(kid)) kid <- eval(substitute(kid), data, parent.frame())
  }

  i.inicio <- findInterval(start.times,breaks, left.open = FALSE)
  i.fin    <- findInterval(start.times+durations,breaks, left.open = FALSE)
  # num.int  <- i.fin - i.inicio

  mapply( function (inicio.1,fin.1) {
      if ( !(is.na(inicio.1) | is.na(fin.1))) {
            breaks[inicio.1:fin.1]
        }
    }, i.inicio, i.fin ,  SIMPLIFY = FALSE ) -> ll

  mapply ( function (vv, ini,fin) {
     vv[1] <- ini
     vv <- c(vv,fin)
     new <-diff(vv)
     new <- list( inicio = ini, epi.durations = new )
  }, ll, start.times,start.times+durations ) -> ll2
  data.table::data.table(t(ll2)) -> DDTT
  DDTT[,kid:=kid]
  DDTT[,inicio:=sapply(inicio, function (e) e)]  # cambia lista a vector
  attr(DDTT,paste0("breaks.",timedim)) <- breaks
  data.table::setnames(DDTT, 1:2,c(timedim,paste0('durations.',timedim)))
  return(DDTT)
}


