## AMPBenchmark

AMPBenchmark is a part of our initative for the improvement of benchmarking standards in the field of antimicrobial peptide (AMP) prediction.

## How to use the public data?

1. Download the sequence data: 
    - [Dropbox link](https://www.dropbox.com/s/uz731rguekt4ysx/AMPBenchmark_public.fasta?dl=0).
    - [GitHub link](https://raw.githubusercontent.com/BioGenies/AMPBenchmark/main/data/AMPBenchmark_public.fasta?token=GHSAT0AAAAAABS4SIUMO3EI6JSQJJ2OC62WYUT5E6A).
2. Benchmark your model against our data.
3. Submit the results in the format described below to the (AMPBenchmark web server)[].

### Data submission format

| ID                      | training_sampling |AMP_probability |
|-------------------------|-------------------|----------------|
| DBAASP_10018_AMP=1_rep1 | dbAMP             |0.97            |
| DBAASP_3217_AMP=1_rep1  | dbAMP             |0.61            |
| ...                     | ...               |...             |


 - **ID**: must contain the sequence ID, as provided in the FASTA headers of the input sequences. 
 - **training_sampling**: has to contain the type of negative sampling method used to train the model. Possible values are: *AMAP*, *AmpGram*, *ampir-mature*, *AMPlify*, *AMPScannerV2*, *CS-AMPPred*, *dbAMP*, *Gabere&Noble*, *iAMP-2L*, *Wang-et-al*, *Witten&Witten*. Remember that a proper benchmark requires you to train your model using every provided sampling method and evaluate it using all sampling methods.
 - **AMP_probability**: has to be in the range between 0 and 1.
 
Exemple data for a random classifer can be downloaded from [Dropbox](https://www.dropbox.com/s/sg93msr3ufvpn4o/sample_data.csv?dl=0).

### Sequence data

The input data is hosted on [Dropbox](https://www.dropbox.com/s/uz731rguekt4ysx/AMPBenchmark_public.fasta?dl=0) and [GitHub](https://raw.githubusercontent.com/BioGenies/AMPBenchmark/main/data/AMPBenchmark_public.fasta?token=GHSAT0AAAAAABS4SIUMO3EI6JSQJJ2OC62WYUT5E6A).

There are two types of the input sequences:

 - positive sequence (e.g., **DBAASP_10718**\_*AMP=1*\_rep1): **IDinDBAASP**\_*class*\_replicateID.
 - negative sequences (e.g., **Seq1896_sampling\_method=Gabere&Noble**\_*AMP=0*\_rep4): **IDandSamplingMethod**\_*class*\_replicateID.
 
AMP sequences are derived from the [DBAASP database](https://dbaasp.org/).

md5 sum of the **AMPBenchmark_public.fasta**: 58f1424c057aaeb64bc632cad6038cad.

## Citation

Our preprint: Katarzyna Sidorczuk, Przemysław Gagat, Filip Pietluch, Jakub Kała, Dominik Rafacz, Laura Bąkała, Jadwiga Słowik, Rafał Kolenda, Stefan Rödiger, Legana C H W Fingerhut, Ira R Cooke, Paweł Mackiewicz, Michał Burdukiewicz **The impact of negative data sampling on antimicrobial peptide prediction**.

See the full analysis at: https://github.com/BioGenies/NegativeDatasets.
