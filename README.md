# HRS-code-for-Brain-communications-manuscript

The content of this repository includes code and a Stata dataset used in the manuscript titled: "Race, polygenic risk and their association with incident dementia among older US adults

May A. Beydoun1,*, †,#; Jordan Weiss2, † Sri Banerjee3; Hind A. Beydoun4; Nicole Noren Hooten1; Michele K. Evans1; Alan B. Zonderman1

1Laboratory of Epidemiology and Population Sciences, NIA/NIH/IRP, Baltimore, MD, 21224
2Department of Demography, University of California Berkeley, Berkeley, CA, 94720
3 College of Health Professions, School of Health Sciences, Walden University, Baltimore, MD, 21202
4Department of Research Programs, Fort Belvoir Community Hospital, Fort Belvoir, VA, 22060

Accepted for publication in Brain Communications, 2022. 

HRS website contains most the data used and can be downloaded directly after registration is approved for individual researchers:
https://hrs.isr.umich.edu/about

1) Stata do file: PGRS_DEMENTIA_STATA_CODE_FINALIZEDfin
2) Datasets used in the code:
2.a. randhrs1992_2018v1: Can be downloaded from the HRS website, RAND longitudinal data: 
2.b. trk2018tr_r: tracker file up to 2018, Can be downloaded from the HRS website. 
2.c. pgenscore4e_r: PGS for european ancestry, can be downloaded from the HRS website. 
2.d. pgenscore4a_r: PGS for African ancestry, can be downloaded from the HRS website.
2.e. FIGURES3_SUPPFIG2: Results from Cox PH models for Model 7, Table 2 used to create Figures 3 and supplemental Figure 2.  

Information about 2.c. and 2.d can be found in:
Ware E, Gard, A., Schmitz, L., Faul, J. . HRS Polygenic Scores – Release 4.3 2006-2012 Genetic Data. Ann Arbor, MI: University of Michigan;2021.

FIGURES3_SUPPFIG2 is directly provided in this repository and can be downloaded as Stata dta file. 


To run the Stata code, all data in 2.a. through 2.e should be placed in a sub-folder named HRS_PROJ/FINAL_DATA, in *.dta format. 
An additional subfolder, named HRS_PROJ/OUTPUT_FINAL should be created to obtain most of the Output in *.smcl format. 
Note that the Figures in *.gph format will initially appear in the DATA subfolder, which is the main directory. However, they can be moved to a different directory
and used to create Figures 2-3, and supplementary Figures 1-2. The Stata journal scheme should be used instead of the Economist scheme where needed. Schemes can be modified using graph editor. 

