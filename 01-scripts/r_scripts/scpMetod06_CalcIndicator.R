# Author: Maria Isabel Arce-Plata
# Date: 28-09-2023
# Description: This script takes the data output from data collected with the 
# form created with KoboToolbox for the rainfall measurement 
# method (https://kf.kobotoolbox.org/#/library/asset/aRuoM2uoCirSKq4jq3TzBR) in this project

library(readr)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)

# Load data
df_registro_diario_lluvia <- read_csv2("00-rawdata/06_MEDICIÓN_DE_LLUVIA_-_latest_version_-_False_-_2021-12-10-16-13-26.csv")
df_iap_parametros <- read_csv("00-rawdata/IAP_parametros.csv")

# Convert date to date format
df_registro_diario_lluvia <- df_registro_diario_lluvia |> mutate(fecha= ymd_hms(dt_fecha_hora),
                                                                 anio = year(fecha),
                                                                 mes = month(fecha),
                                                                 juliano = yday(fecha))

df_registro_mes_lluvia <- df_registro_diario_lluvia |> group_by(anio,mes) |> 
  summarise(precipitacion=sum(nm_precipitacion))

# join with parameters from historic data
df_mes_parametros <- df_registro_mes_lluvia |> left_join(df_iap_parametros,by=c("mes"="dt_mes"))

df_mes_parametros <- df_mes_parametros |> mutate(iap_p= ((nm_fe_p*precipitacion)-(nm_mediana_precipitacion_historico))/(nm_promedio_p90_historico-nm_mediana_precipitacion_historico),
                                                 iap_n= ((nm_fe_n*precipitacion)-(nm_mediana_precipitacion_historico))/(nm_promedio_p10_historico-nm_mediana_precipitacion_historico),
                                                 iap = if_else(precipitacion < nm_mediana_precipitacion_historico, iap_p, iap_n))

# Create rainfall categories
breaks <- c(-Inf,-3,-2,-1,-0.5,0.49999999,0.99999999,1.99999999,2.99999999,Inf)
labels <- c("Extremely dry","Very dry","Moderately dry","Slightly dry","Near normal","Slightly wet","Moderately wet","Very wet","Etremely wet")

df_mes_parametros <- df_mes_parametros |> mutate(iap_label= cut(iap,breaks,labels))

rainfall_anomaly_index <- df_mes_parametros |> ungroup() |> select(anio,mes,iap,iap_label)

# save table with indicator value
write_csv(rainfall_anomaly_index,"02-outdata/rainfall_anomaly_index.csv")

df_registro_diario_lluvia <- df_registro_diario_lluvia |> left_join(rainfall_anomaly_index,by=c("anio","mes")) |> 
  rename(precipitacion_cm3=nm_precipitacion)
df_registro_diario_lluvia_long <- df_registro_diario_lluvia |> pivot_longer( cols=c("precipitacion_cm3","iap"),names_to="category",values_to = "values")

# make plot
img_rainfall_ts <- ggplot(df_registro_diario_lluvia_long, aes(x=juliano,y=values,col=category)) + geom_line() + theme_bw()

ggsave("03-figs/img_rainfall_ts.jpg",img_rainfall_ts)
