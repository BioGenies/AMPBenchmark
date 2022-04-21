## AMPBenchmark

AMPBenchmark is a part of our initative for the improvement of benchmarking standards in the field of antimicrobial peptide (AMP) prediction.

## How to use the public data?

1. Download the sequence data ([Dropbox link](https://www.dropbox.com/s/uz731rguekt4ysx/AMPBenchmark_public.fasta?dl=0)).
2. Benchmark your model against our data.
3. Submit the results in the format described below to the AMPBenchmark web server.

### Data submission format

| ID                      | sampling_method |AMP_probability |
|-------------------------|-----------------|----------------|
| DBAASP_10018_AMP=1_rep1 | dbAMP           |0.97            |
| DBAASP_3217_AMP=1_rep1  | dbAMP           |0.61            |
| ...                     | ...             |...             |


 - **ID**: must contain the sequence ID, as provided in the FASTA headers of the input sequences. 
 - **sampling_method**: has to contain the type of negative sampling method used to train the model. Possible values are: *iAMP-2L*, *AmPEP*, *dbAMP*, *ampir-precursor*, *CS-AMPPred*, *Wang-et-al*, *AmpGram*, *Witten&Witten*, *AMPScannerV2*, *Gabere&Noble*, *AMAP*, *AMPlify*. Remember that a proper benchmark requires you to train your model using every provided sampling method and evaluate it using all sampling methods.
 - **AMP_probability**: has to be in the range between 0 and 1.

### Input data

Due to its size, the input data is hosted on [Dropbox](https://www.dropbox.com/s/uz731rguekt4ysx/AMPBenchmark_public.fasta?dl=0).

There are two main types of the input sequences:

 - positive sequence (e.g., <span style="color:blue">DBAASP_10718</span>_<span style="color:red">AMP=1</span>_<span style="color:green">rep1</span>): <span style="color:blue">IDinDBAASP</span>_<span style="color:red">class</span>_<span style="color:green">replicateID</span>.
 - negative sequences (e.g., <span style="color:blue">Seq1896_sampling_method=Gabere&Noble</span>_<span style="color:red">AMP=0</span>_<span style="color:green">rep1</span>_AMP=0_rep4): <span style="color:blue">IDandSamplingMethod</span>_<span style="color:red">class</span>_<span style="color:green">replicateID</span>.

md5 sum of the **AMPBenchmark_public.fasta**: 58f1424c057aaeb64bc632cad6038cad.

## Citation

This repository contains the data and code necessary to reproduce the results from the preprint: Katarzyna Sidorczuk, Przemysław Gagat, Filip Pietluch, Jakub Kała, Dominik Rafacz, Laura Bąkała, Jadwiga Słowik, Rafał Kolenda, Stefan Rödiger, Legana C H W Fingerhut, Ira R Cooke, Paweł Mackiewicz, Michał Burdukiewicz **The impact of negative data sampling on antimicrobial peptide prediction**.

See the full analysis at: https://github.com/BioGenies/NegativeDatasets.
