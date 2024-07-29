
# AMPBenchmark

AMPBenchmark is a part of our initative for the improvement of
benchmarking standards in the field of antimicrobial peptide (AMP)
prediction.

## How to use the public data?

1.  Download the benchmark sequence data:
    - [Dropbox
      link](https://www.dropbox.com/scl/fi/6hxboi6xy1jm1q1ie6vyg/AMPBenchmark_public.fasta?rlkey=3egb368kyh347fdfamcfd75m0&st=ld02vyiv&dl=0).
    - [GitHub
      link](https://raw.githubusercontent.com/BioGenies/AMPBenchmark/main/data/AMPBenchmark_public.fasta?token=GHSAT0AAAAAABS4SIUMO3EI6JSQJJ2OC62WYUT5E6A).
2.  Download the training sequence data for all methods and
    replications:
    - [Dropbox
      link](https://www.dropbox.com/scl/fo/f8kdfgoa8htsvpc79v0u2/ANOcYXz3fSRyE5kEumDDsVs?rlkey=a0su8jyn5nsjnzs2gkqya5n24&st=xd69dycx&dl=0).
3.  Train your model using each of the training data set (class of a
    sequence is denoted by AMP=1 for AMPs and AMP=0 for negative
    samples, see [Sequence
    data](https://github.com/BioGenies/AMPBenchmark#sequence-data)
    section for details.)
4.  Benchmark trained models against our data. Make sure to use a subset
    of sequences for appropriate replication (replication number is
    denoted by, e.g. rep=1, see [Sequence
    data](https://github.com/BioGenies/AMPBenchmark#sequence-data)
    section for details.)
5.  Submit the results in the format described below to the
    [AMPBenchmark web server](http://biogenies.info/AMPBenchmark/).

### Data submission format

| ID                      | training_sampling | AMP_probability |
|-------------------------|-------------------|-----------------|
| DBAASP_10018_AMP=1_rep1 | dbAMP             | 0.97            |
| DBAASP_3217_AMP=1_rep1  | dbAMP             | 0.61            |
| …                       | …                 | …               |

- **ID**: must contain the sequence ID, as provided in the FASTA headers
  of the input sequences.
- **training_sampling**: has to contain the type of negative sampling
  method used to train the model. Possible values are: *AMAP*,
  *AmpGram*, *ampir-mature*, *AMPlify*, *AMPScannerV2*, *CS-AMPPred*,
  *dbAMP*, *Gabere&Noble*, *iAMP-2L*, *Wang-et-al*, *Witten&Witten*.
  Remember that a proper benchmark requires you to train your model
  using every provided sampling method and evaluate it using all
  sampling methods using appropriate replication.
- **AMP_probability**: has to be in the range between 0 and 1.

Example data for a random classifier can be downloaded from
[Dropbox](https://www.dropbox.com/scl/fi/xqeqdsygkxjg5qt2b7ezg/sample_data.csv?rlkey=ql7gtoumuecwbg5tr0frl81bb&st=w7pdevvn&dl=0).

### Sequence data

The input data is hosted on
[Dropbox](https://www.dropbox.com/scl/fi/6hxboi6xy1jm1q1ie6vyg/AMPBenchmark_public.fasta?rlkey=3egb368kyh347fdfamcfd75m0&st=wj8wc93f&dl=0)
and
[GitHub](https://raw.githubusercontent.com/BioGenies/AMPBenchmark/main/data/AMPBenchmark_public.fasta?token=GHSAT0AAAAAABS4SIUMO3EI6JSQJJ2OC62WYUT5E6A).
Note that this single file contains data for all replications which
should be used separately with appropriate replications of training
sets.

The training data sets are hosted on
[Dropbox](https://www.dropbox.com/scl/fo/f8kdfgoa8htsvpc79v0u2/ANOcYXz3fSRyE5kEumDDsVs?rlkey=a0su8jyn5nsjnzs2gkqya5n24&st=vpcy0lyc&dl=0)
and follow the same naming convention.

There are two types of the input sequences:

- positive sequence (e.g., **DBAASP_10718**\_*AMP=1*\_rep1):
  **IDinDBAASP**\_*class*\_replicateID.
- negative sequences (e.g.,
  **Seq1896_sampling_method=Gabere&Noble**\_*AMP=0*\_rep4):
  **IDandSamplingMethod**\_*class*\_replicateID.

AMP sequences are derived from the [DBAASP
database](https://dbaasp.org/).

md5 sum of the **AMPBenchmark_public.fasta**:
58f1424c057aaeb64bc632cad6038cad.

## Citation

Katarzyna Sidorczuk, Przemysław Gagat, Filip Pietluch, Jakub Kała,
Dominik Rafacz, Laura Bąkała, Jadwiga Słowik, Rafał Kolenda, Stefan
Rödiger, Legana C H W Fingerhut, Ira R Cooke, Paweł Mackiewicz, Michał
Burdukiewicz, Benchmarks in antimicrobial peptide prediction are biased
due to the selection of negative data, Briefings in Bioinformatics,
2022;, bbac343, <https://doi.org/10.1093/bib/bbac343>.

## Important links

- <https://github.com/BioGenies/NegativeDatasets>: the repository
  containing the code necessary to reproduce results of our analysis.
- <https://github.com/BioGenies/NegativeDatasetsArchitectures>: the
  repository containing all architectures considered in our analysis.
- <https://github.com/BioGenies/AMPBenchmark>: the source code of
  AMPBenchmark.

## Contact

If you have any questions, suggestions or comments, contact [Michal
Burdukiewicz](mailto:michalburdukiewicz@gmail.com).

## Changelog

- 2024/07/29: updated dropbox links.
- 2023/01/11: fixed data processing.
