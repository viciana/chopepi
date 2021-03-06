% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calTime.R
\name{cal.yr2}
\alias{cal.yr2}
\title{cal.yr2}
\usage{
cal.yr2(calendar.date, decimal.precision = 3)
}
\arguments{
\item{calendar.date}{vector con fechas (classe Date) que convertir en
años}

\item{decimal.precision}{decimales de aprosimacion de año}
}
\value{
valor númerico en años decimales (3 decimales de precisión)
}
\description{
Transforma una fecha (objeto de clase Date) en un valor de años
 decimal.  tiene en cuenta si es un año bisiesto. Correcion de los
 años seculares (no bisiestos) menos los multiplos de 400.  Puede
 crea pequeño desplazamientos de los aniversarios en años bisiestos
 (un dia antes despues del 29 de febrero). Este pequeño
 incoveniente permite trabaja como si las longitud de los años
 fueran iguales idependientemente de las irrregularidades
 introducidas por los años bisiestos en el calendario gregoriano. Y
 permite calculos aritmetico sencillos con edad y periodo sobre un
 diagrama de Lexis. Otros sistemas de trandformacion a decimales
 como Epi::cal.yr usan una formulamas simple,
 (as.numeric(x)/365.25 + 1970), tienen el inconveniente de
 producir edades cumplidas aproximadas
}
