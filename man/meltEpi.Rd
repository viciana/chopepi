% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meltEpi.R
\name{meltEpi}
\alias{meltEpi}
\title{meltEpi}
\usage{
meltEpi(
  epi.breaks,
  type = c("factor", "left", "middle", "right", "integer"),
  dec.precision = 3
)
}
\arguments{
\item{epi.breaks}{objeto episodio particionado, al menos por una
dimensión temporal}

\item{type}{tipo de etiqueta asignada a cada banda dimensional}

\item{dec.precision}{escala de precion para las comparaciones}
}
\value{
un data.table donde cada registro de episodio se ha divido en tamtos
        subepisodios como elemetos haya en el vectos de troceado generado
        prevaimente por la combinacion de funciones \code{chop} y
        \code{combine2c}
}
\description{
Toma como entrada una tabla de episodios, que ha sido preprocesado por
las funcion \code{chopepi::chop} conteniendo la varible  "durations.<dim.tmp>",
el tiempo de comienzo del episodios, y una lista con el vector de subepisodio troceado
por una o mas escalas temporales. Tras su proceso se genera una nueva tabla
con un registro individual con cada uno de los subepisodio contenidos en el
episodio madre.
}
\examples{

\donttest{
epi.original <- data.table::data.table(
 kid = 1:3 ,
 start.times  = c(16,21,32)     ,
 durations  = c(12.5,19.4, 7.3) ,
 Cst = c(0,0,0),
 Xst = c(1,1,1)
 )

chop (start.times =  start.times,
     durations   = durations,
     breaks = seq(10,50, by=5),
     timedim = 'edad', data = epi.original)  -> epi.seq

meltEpi(epi.seq) -> epi.sub
epi.sub
}

}
