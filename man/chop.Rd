% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chop.R
\name{chop}
\alias{chop}
\title{chop}
\usage{
chop(
  start.times,
  durations,
  breaks,
  kid = 1:length(start.times),
  timedim = "Time",
  data = NULL
)
}
\arguments{
\item{start.times}{Vector con los puntos temporales (tiempos de
comienzo) de inicio de cada episodio}

\item{durations}{Vector con las duraciones (en unidades de tiempo)
de cada episodio. El instante de de terminación de cada
episodio es start.times + durations}

\item{breaks}{Vector con los puntos de corte (chop) en la dimensión
temporal utilizada.  (usa la funcion "cut" a la que se le
pueden pasar el parametros "right")}

\item{kid}{clave primaria de episodio}

\item{timedim}{nombre de la dimension}

\item{data}{data.frame con los episodios}
}
\value{
un objeto del tipo data.table donde cada fila contiene tres
    variables: (1) una clave de identificacion de episodio "kid",
    (2) una variable con el nombre de la dimension temporal con el
    punto de inicio del episodio, (3) un vector con las duraciones
    de los sub-episodios en los que se ha particionado el episodio
    origina segun la regla dada por los puntos de corte. El
    attributo breaks.<dimension> contiene la regla utilizada
}
\description{
\code{chop} trocea la duración de un \emph{episodio}, dado unos
puntos de corte, en una determinada escala de tiempo (edad,
calendario o duración desde un evento dado..)
}
\section{Definiciones}{


Un episodio es una intervalo temporal con una duración dada. Esta
fijado en su origen a un instante termporal concreto. Un episodio
tienen principio y fin (esta temporamente datado). Un episodio
puede estar censurado por la derecha a partir de una determinada
fecha termina su observación. Para la ejecución de esta esta
función es indistinto que el cominzo o fin del episodio sea por una
transición entre estados o por censura.
}

\examples{
\donttest{
    start.times <- c(16,21,32) ;  durations <- c(12.5,19.4, 7.3) ; breaks <- seq(10,50, by=5)
    chop (start.times, durations,  breaks ) -> kk ; kk
    # comprueba
    cbind(sapply(kk$epi.durations, sum) , durations)
    # borra termporales
    rm(start.times,durations,breaks)
    }
}
