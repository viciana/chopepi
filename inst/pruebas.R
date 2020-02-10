## Prepara objeto de muestra para pruebas.
## supuesta historia reproductiva de 3 ikeyiduos
##
##
##

require(knitr)
require(data.table)
require(chopepi)

### Crea tabla fuentes para ejemplo
###
data.table(ikey=c(1L,1L,2L,2L,2L,3L,3L),
           seq.epi=c(1L,2L,1L,2L,3L,1L,2L),
           date.entry=as.Date(c("1958/03/13","1981/05/14","1955/07/10",
                               "1976/08/07","1981/05/30",
                               "1960/02/29","1979/02/28"),"%Y/%m/%d"),
           Cst.par=c(0L,1L,0L,1L,2L,0L,1L),
           Xst.par=c(1L,1L,1L,2L,3L,1L,1L)
           )-> epi.raw

end.tracking <-  as.Date(c("1985/01/01"), "%Y/%m/%d")

epi.raw[,':='(span.days  = as.integer(c(date.entry[-1],end.tracking) - date.entry),
           span.years = cal.age2(date.entry,c(date.entry[-1],end.tracking) ),
           age.entry  = cal.age2(date.entry[1],date.entry))
        ,ikey]

epi.raw[, ':='(kepi=ikey*100L+seq.epi,year.entry=  cal.yr2(date.entry)) ]

epi.raw[,c(1:2,9,3,10,8,7,6,4:5)]  -> epi.raw



## particiona por  edad ##############################
chop(start.times =  age.entry,
     durations = span.years,
     breaks =  c(0,seq(15,100,by=5)),
     kid    = kepi,
     timedim = 'age',
     data = epi.raw) -> cepi.age

meltEpi(cepi.age) -> epi.chop.age

addCXst(epi.chop.age,epi.raw, Cst = 'Cst.par',
        Xst = 'Xst.par', id.original = 'kepi') -> epi.chop.age

epi.chop.age[,sum(duration)] - epi.raw[,sum(span.days/365.25)]  # comprueba ~ 0

## particiona por periodo ##############################
chop(start.times =  year.entry,
     durations = span.years,
     breaks =  c(1950,seq(1975,1990,by=5)),
     kid    = kepi,
     timedim = 'period',
     data = epi.raw) -> cepi.period

meltEpi(cepi.period) -> epi.chop.period

addCXst(epi.chop.period,epi.raw, Cst = 'Cst.par',
        Xst = 'Xst.par', id.original = 'kepi') -> epi.chop.period

epi.chop.period[,sum(duration)] - epi.raw[,sum(span.days/365.25)]  # comprueba ~ 0

## combina particionado de edad y periodo.

combine2c(cepi.age, cepi.period, dec.precision = 1) ->  cepi.age.period


meltEpi(cepi.age.period) -> epi.chop.age.period

addCXst(epi.chop.age.period,epi.raw, Cst = 'Cst.par',
        Xst = 'Xst.par', id.original = 'kepi') -> epi.chop.age.period

epi.chop.age.period[,sum(duration)] - epi.raw[,sum(span.days/365.25)]  # # comprueba ~ 0

## Muestra resultados:

knitr::kable(epi.raw)
knitr::kable(epi.chop.age)
knitr::kable(epi.chop.period)
knitr::kable(epi.chop.age.period)

knitr::kable(cepi.age)
knitr::kable(cepi.period)
knitr::kable(cepi.age.period)

