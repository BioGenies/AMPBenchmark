## About

AMPBenchmark is a part of our initative for the improvement of benchmarking standards in the field of antimicrobial peptide (AMP) prediction.

## How to use the public data?

1. Download the sequence data [Dropbox link](https://www.dropbox.com/s/uz731rguekt4ysx/AMPBenchmark_public.fasta?dl=0).
2. Benchmark your model against our data.
3. Submit the results in the format described below to the AMPBenchmark web server.

### Data submission format

| ID                      | AMP_probability |
|-------------------------|------------|
| DBAASP_10018_AMP=1_rep1 | 0.97       |
| DBAASP_3217_AMP=1_rep1  | 0.61       |
| ...                     | ...        |

Remember that the **ID** column must contain the sequence ID, as provided in the FASTA headers of the input sequences. The *AMP_probability** has to be in the range between 0 and 1.

### Input data format

Due to its size, the input data is hosted on [Dropbox](https://www.dropbox.com/s/uz731rguekt4ysx/AMPBenchmark_public.fasta?dl=0).

md5 sum of the **AMPBenchmark_public.fasta**: 58f1424c057aaeb64bc632cad6038cad.

## Citation

This repository contains the data and code necessary to reproduce the results from the preprint: Katarzyna Sidorczuk, Przemysław Gagat, Filip Pietluch, Jakub Kała, Dominik Rafacz, Laura Bąkała, Jadwiga Słowik, Rafał Kolenda, Stefan Rödiger, Legana C H W Fingerhut, Ira R Cooke, Paweł Mackiewicz, Michał Burdukiewicz **The impact of negative data sampling on antimicrobial peptide prediction**.

See the full analysis at: https://github.com/BioGenies/NegativeDatasets.
