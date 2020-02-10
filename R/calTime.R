#'  cal.yr2
#'
#'
#'  Transforma una fecha (objeto de clase Date) en un valor de años
#'  decimal.  tiene en cuenta si es un año bisiesto. Correcion de los
#'  años seculares (no bisiestos) menos los multiplos de 400.  Puede
#'  crea pequeño desplazamientos de los aniversarios en años bisiestos
#'  (un dia antes despues del 29 de febrero). Este pequeño
#'  incoveniente permite trabaja como si las longitud de los años
#'  fueran iguales idependientemente de las irrregularidades
#'  introducidas por los años bisiestos en el calendario gregoriano. Y
#'  permite calculos aritmetico sencillos con edad y periodo sobre un
#'  diagrama de Lexis. Otros sistemas de trandformacion a decimales
#'  como Epi::cal.yr usan una formulamas simple,
#'  (as.numeric(x)/365.25 + 1970), tienen el inconveniente de
#'  producir edades cumplidas aproximadas
#'
#'
#'
#' @param calendar.date vector con fechas (classe Date) que convertir en
#'     años
#'
#' @param decimal.precision decimales de aprosimacion de año
#'
#' @export
#'
#' @return   valor númerico en años decimales (3 decimales de precisión)
#'

cal.yr2 <- function(calendar.date, decimal.precision = 3 ) {
  yy  <- data.table::year(calendar.date)
  lead.year <-  ifelse(yy %% 4 == 0,
                ifelse(!(yy %% 400 == 0) & (yy %% 100 == 0),F,T),F)
  w.years <- ifelse(lead.year,366,365)
  # Tiempo comienzo a 00:00 (dia cumplido). Tiempo posicionado en
  # extremo izquiedo del granuloro
  yy <-  data.table::year(calendar.date) +
         data.table::yday(calendar.date)/w.years - 1/w.years  # al comienzo del dia.
  yy <- floor(10^decimal.precision*yy)/10^decimal.precision
  return ( yy )
}


#' cal.age2
#'
#' Calcula edad exacta en años decimales.
#'
#' @param date.start  fechas de inicio (nacimiento habitualmente)
#'
#' @param date.end    fecha en la que se calcula la edad exacta
#'
#' @param decimal.precision decimales de aprosimacion de año
#'
#' @importFrom data.table year yday data.table
#'
#' @export
#'
#' @example
#'
#' # Hay pequeñas errores () con los nacidos en años bisisestos, con las fechas
#' # posterior al 28-feb
#' cal.age2 (as.Date('19800301','%Y%m%d'),as.Date('19820301','%Y%m%d'))
#' cal.age2 (as.Date('19810301','%Y%m%d'),as.Date('19820301','%Y%m%d'))
#' cal.age2 (as.Date('19800201','%Y%m%d'),as.Date('19820201','%Y%m%d'))
#' cal.age2 (as.Date('19800229','%Y%m%d'),as.Date('19820301','%Y%m%d'))
#' cal.age2 (as.Date('19800301','%Y%m%d'),as.Date('19820301','%Y%m%d'))

cal.age2 <- function(date.start, date.end, decimal.precision = 3 ) {

  lead.year <-  ifelse(year(date.end) %% 4 == 0,
                ifelse(!(year(date.end) %% 400 == 0) &
                        (year(date.end) %% 100 == 0),F,T),F)
  w.years <- ifelse(lead.year,366,365)
  bd <- yday(date.start)
  birthday <- date.end - yday(date.end) + yday(date.start)
  fulfilled <- as.logical(sign(date.end-birthday)+1)
  age <-  year(date.end) - year(date.start)
  yy.days <-  yday(date.end) -  yday(date.start)
  age <- age +  yy.days/w.years
  age <- floor(10^decimal.precision*age)/10^decimal.precision
  data.table(date.start, date.end, birthday, fulfilled, yy.days , age )

  return ( age )
}

