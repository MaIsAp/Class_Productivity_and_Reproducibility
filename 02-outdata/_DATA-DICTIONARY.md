## Data dictionary

 

For the encoding of variables in the KoBoToolBox formats, the name of each question begins with two letters indicating the type of answer:

dt - for dates and times

nm - for numerical values

tx - for text type response

ct - for categorical responses

fl - for attachments

However, here since the labels for the graphs will be taken from this table, the labels were converted to a more human readable format.

### rainfall_anomaly_index
| Field         | Type   | Comments                                                                               |
|-------------------|-------------------|-----------------------------------|
| fecha         | Date   | Sampling date (dt_fecha_hora)                                                          |
| anio          | Int    | Year from "fecha"                                                                      |
| mes           | Int    | Month from "fecha"                                                                     |
| juliano       | Int    | Julian day of "fecha" [1-365(6)]                                                       |
| p10           | Double | 10th percentile value for historic secondary data                                      |
| p90           | Double | 90th percentile value for historic secondary data                                      |
| precipitacion | Int    | Level of water at the container in cm3 (nm_precipitacion in medicion_lluvia_registros) |


<!--| codigo        | String | Sampling point code (medicion_lluvia)                                                  |
| nombre_vereda | String | Locality name                                                                          |
| asociacion    | String | Local community association in charge of monitoring                                    |-->
