# hse21_hw3
## MultiQC

### Проверка качества чтений

![image](/img/M_QC/G_S.png)
![image](/img/M_QC/S_C.png)
![image](/img/M_QC/S_Q_H.png)
![image](/img/M_QC/PS_Q_S.png)
![image](/img/M_QC/PS_GC_Content.png)
![image](/img/M_QC/S_Chek.png)

## Статистика

![image](/img/Statistics.png)

### Общая таблица
| ID образца | Тип образца  | Общее кол-во исходных чтений | Чтений, успешно откартированные на геном | Уникально откартированные чтения | Чтения, которые попали на гены |
|------------|:------------:|:----------------------------:|:----------------------------------------:|:--------------------------------:|:------------------------------:|
| SRR3414629 | reprogrammed | 21106089                     | 20510113 / 97.18 %                       | 18375888 / 87.06 %               | 16049609                       |
| SRR3414630 | reprogrammed | 15244711                     | 14832680 / 97.3 %                        | 13186139 / 86.5 %                | 11465324                       |
| SRR3414631 | reprogrammed | 24244069                     | 23547686 / 97.13 %                       | 20928945 / 86.33 %               | 18408851                       |
| SRR3414635 | control      | 20956475                     | 10395865 / 97.32 %                       | 18428317 / 87.94 %               | 16275997                       |
| SRR3414636 | control      | 20307147                     | 19757059 / 97.29 %                       | 17825380 / 87.78 %               | 15757580                       |
| SRR3414637 | control      | 20385570                     | 19847291 / 97.36 %                       | 17844858 / 87.54 %               | 15736978                       |

## Графики из анализа DESeq2
Google Collab with R: https://colab.research.google.com/drive/1ZDhx63ny1jTZbsVh_ZV5tr0URyL4GBsz#scrollTo=VrnRoY5nF6QO

### Тепловая карта
![image](/img/R/Pheatmap.png)

### MA-график
![image](/img/R/MA-graph.png)

### Тепловая карта для генов
![image](/img/R/Heatmap.png)

### Гены, которые значительно поменяли эксперссию ("Normalized count")
![image](/img/R/NC_1.png)
![image](/img/R/NC_2.png)
![image](/img/R/NC_3.png)
![image](/img/R/NC_4.png)
![image](/img/R/NC_5.png)
![image](/img/R/NC_6.png)
