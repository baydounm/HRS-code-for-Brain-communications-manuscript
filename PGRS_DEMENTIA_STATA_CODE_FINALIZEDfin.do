/////CURRENT DIRECTORY///////

cd "D:\HRS_PROJ\FINAL_DATA"

/////////////////STEP 1: MERGE RAND HRS LONGITUDINAL FILE WITH POLYGENIC RISK SCORE DATASET///////////////////

/////RAND HRS LONGITUDINAL FILE//////

use randhrs1992_2018v1,clear

su hhidpn

destring hhid, replace
destring pn, replace


capture drop HHIDPN
egen HHIDPN = concat(hhid pn)



save, replace


//////POLYGENIC RISK SCORE DATA///////

use pgenscore4a_r,clear

su
destring hhid, replace
destring pn, replace


capture drop HHIDPN
egen HHIDPN = concat(hhid pn)


save, replace


use pgenscore4e_r,clear
su

destring hhid, replace
destring pn, replace


capture drop HHIDPN
egen HHIDPN = concat(hhid pn)



save, replace


////////////MERGE THE 3 DATASETS TOGETHER////////////////////////


use pgenscore4e_r,clear
destring HHIDPN, replace
sort HHIDPN
save pgenscore4e_r_final, replace


use pgenscore4a_r,clear
destring HHIDPN,replace
sort HHIDPN
save pgenscore4a_r_final, replace

use randhrs1992_2018v1,clear
destring HHIDPN,replace
sort HHIDPN
save randhrs1992_2018v1final, replace


use randhrs1992_2018v1final, clear
merge HHIDPN using pgenscore4e_r_final
tab _merge
capture drop _merge
sort HHIDPN
save randhrs1992_2018v1finalPGS,replace
merge HHIDPN using pgenscore4a_r_final
tab _merge
capture drop _merge
sort HHIDPN
save, replace

tab rarace if  E4_NEUROT_SSGAC16~=.
tab rarace if  A4_NEUROT_SSGAC16~=.

keep HHIDPN hhid pn r* in* ha* h9* filever PC1_5A- A4_GCOG2_CHARGE18

save HRS_PAPER_PGRS_DEMENTIA_FINAL, replace

/////////////////////STEP 2: MERGE WITH TRACKER FILE/////////////////////////////

**Tracker file**

use trk2018tr_r,clear
destring hhid, replace
destring pn, replace
capture drop HHIDPN
egen HHIDPN = concat(hhid pn)
destring HHIDPN, replace
sort HHIDPN

save trk2018tr_r_final, replace


use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear
capture drop _merge
sort HHIDPN
save, replace
merge HHIDPN using trk2018tr_r_final

save HRS_PAPER_PGRS_DEMENTIA_FINAL,replace

//GENERATE DEMOGRAPHICS FILES FOR YEARS 2006 through 2018//

**2006 demographics**
use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear

keep HHIDPN ragender r8agey_e  raracem inw8

save demog2006, replace

keep if inw8==1

capture drop wave
gen wave=8

capture drop year
gen year=2006

capture drop visit
gen visit=0

save, replace

capture rename r8agey_e AGE
capture rename ragender SEX
capture rename raracem RACE
capture drop inw8

save demog2006long, replace


**2008 demographics**

use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear

keep HHIDPN ragender r9agey_e  raracem inw9

save demog2008, replace

keep if inw9==1

capture drop wave
gen wave=9

capture drop year
gen year=2008

capture drop visit
gen visit=0

save, replace

capture rename r9agey_e AGE
capture rename ragender SEX
capture rename raracem RACE
capture drop inw9

save demog2008long, replace


**2010 demographics**

use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear

keep HHIDPN ragender r10agey_e  raracem inw10

save demog2010, replace

keep if inw10==1

capture drop wave
gen wave=10

capture drop year
gen year=2010

capture drop visit
gen visit=0

save, replace

capture rename r10agey_e AGE
capture rename ragender SEX
capture rename raracem RACE
capture drop inw10

save demog2010long, replace



**2012 demographics**

use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear

keep HHIDPN ragender r11agey_e  raracem inw11

save demog2012, replace

keep if inw11==1

capture drop wave
gen wave=11

capture drop year
gen year=2012

capture drop visit
gen visit=0

save, replace

capture rename r11agey_e AGE
capture rename ragender SEX
capture rename raracem RACE
capture drop inw11

save demog2012long, replace


**2014 demographics**

use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear

keep HHIDPN ragender r12agey_e  raracem inw12

save demog2014, replace

keep if inw12==1

capture drop wave
gen wave=12

capture drop year
gen year=2014

capture drop visit
gen visit=0

save, replace

capture rename r12agey_e AGE
capture rename ragender SEX
capture rename raracem RACE
capture drop inw12

save demog2014long, replace


**2016 demographics**

use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear

keep HHIDPN ragender r13agey_e  raracem inw13

save demog2016, replace

keep if inw13==1

capture drop wave
gen wave=13

capture drop year
gen year=2016

capture drop visit
gen visit=0

save, replace

capture rename r13agey_e AGE
capture rename ragender SEX
capture rename raracem RACE
capture drop inw13

save demog2016long, replace


**2018 demographics**

use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear

keep HHIDPN ragender r14agey_e  raracem inw14

save demog2018, replace

keep if inw14==1

capture drop wave
gen wave=14

capture drop year
gen year=2018

capture drop visit
gen visit=0

save, replace

capture rename r14agey_e AGE
capture rename ragender SEX
capture rename raracem RACE
capture drop inw14

save demog2018long, replace


/////APPEND DEMOGRAPHICS///////


use demog2006long,clear
append using demog2008long
append using demog2010long
append using demog2012long
append using demog2014long
append using demog2016long
append using demog2018long


save demog2006_2018long, replace

tab wave

///////CREATE DEMENTIA, ALZHEIMER'S DISEASE AND MEMORY PROBLEMS FOR EACH YEAR (2006-2018), VARIABLES////////


use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear



/*MEMORY PROBLEMS*/

**R8MEMRY
**R9MEMRY

**R8MEMRYQ
**R9MEMRYQ


**R8MEMRYE
**R9MEMRYE


**R8MEMRYF
**R9MEMRYF


/*2006*/


capture drop MEMORY_PROB_2006
gen MEMORY_PROB_2006=0
replace MEMORY_PROB_2006=1 if (r8memry==1)

tab  MEMORY_PROB_2006


/*2008*/


capture drop MEMORY_PROB_2008
gen MEMORY_PROB_2008=0
replace MEMORY_PROB_2008=1 if (r8memry==1 | r9memry==1)

tab  MEMORY_PROB_2008




/*ALZHEIMER'S DISEASE*/

**R10ALZHE
**R11ALZHE
**R12ALZHE
**R13ALZHE

**R10ALZHEQ
**R11ALZHEQ
**R12ALZHEQ
**R13ALZHEQ


**R11ALZHEF
**R12ALZHEF
**R13ALZHEF



/*2010*/

capture drop AD_2010
gen AD_2010=0
replace AD_2010=1 if (r10alzhe==1)

tab  AD_2010

/*2012*/

capture drop AD_2012
gen AD_2012=0
replace AD_2012=1 if (r10alzhe==1 | r11alzhe==1)

tab  AD_2012


/*2014*/

capture drop AD_2014
gen AD_2014=0
replace AD_2014=1 if (r10alzhe==1 | r11alzhe==1 | r12alzhe==1)

tab  AD_2014


/*2016*/


capture drop AD_2016
gen AD_2016=0
replace AD_2016=1 if (r10alzhe==1 | r11alzhe==1 | r12alzhe==1 | r13alzhe==1)

tab  AD_2016



/*2018*/


capture drop AD_2018
gen AD_2018=0
replace AD_2018=1 if (r10alzhe==1 | r11alzhe==1 | r12alzhe==1 | r13alzhe==1 | r14alzhe==1 )

tab  AD_2018


/*DEMENTIA*/

**R10DEMEN
**R11DEMEN
**R12DEMEN
**R13DEMEN

**R10DEMENQ
**R11DEMENQ
**R12DEMENQ
**R13DEMENQ


**R10DEMENE
**R11DEMENE
**R12DEMENE
**R13DEMENE


/*2010*/

capture drop ADRD_2010
gen ADRD_2010=0
replace ADRD_2010=1 if (r10demen==1 | r10alzhe==1)

tab  ADRD_2010

/*2012*/

capture drop ADRD_2012
gen ADRD_2012=0
replace ADRD_2012=1 if (r10demen==1 | r10alzhe==1 | r11demen==1 | r11alzhe==1)

tab  ADRD_2012


/*2014*/

capture drop ADRD_2014
gen ADRD_2014=0
replace ADRD_2014=1 if (r10demen==1 | r10alzhe==1 | r11demen==1 | r11alzhe==1 | r12demen==1 | r12alzhe==1)

tab  ADRD_2014


/*2016*/


capture drop ADRD_2016
gen ADRD_2016=0
replace ADRD_2016=1 if (r10demen==1 | r10alzhe==1 | r11demen==1 | r11alzhe==1 | r12demen==1 | r12alzhe==1 | r13demen==1 | r13alzhe==1)

tab  ADRD_2016



/*2018*/


capture drop ADRD_2018
gen ADRD_2018=0
replace ADRD_2018=1 if (r10demen==1 | r10alzhe==1 | r11demen==1 | r11alzhe==1 | r12demen==1 | r12alzhe==1 | r13demen==1 | r13alzhe==1 | r14demen==1 | r14alzhe==1)

tab  ADRD_2018


//////////////////////////////2008-2012 cohort selection: with data on AD//////////////////////////////////////////


**FULL SAMPLE 1, N=42,233**

capture drop sample1
gen sample1=1 if ragender~=.
replace sample1=0 if sample1~=1

tab sample1

**FULL SAMPLE 2: DATA FOR 2008, 2010 OR 2012: N=24,733 of initial N=42,233**

capture drop sample2
gen sample2=1 if  inw9==1 & ragender~=. | inw10==1 & ragender~=.| inw11==1 & ragender~=.
replace sample2=0 if sample2~=1 & ragender~=.

tab sample2

**SAMPLE 2AGE55: SAMPLE 2 WITH AGE AT BASELINE (END OF 2008) RESTRICTED TO 55+:  N=16,032 of initial N=42,233****


capture drop AGE_BASELINE2008
gen AGE_BASELINE2008=r9agey_e

su AGE_BASELINE2008


capture drop sample2AGE55
gen sample2AGE55=.
replace sample2AGE55=1 if sample2==1 & AGE_BASELINE2008>=55 & AGE_BASELINE2008~=. 
replace sample2AGE55=0 if sample2AGE55~=1 & sample1==1

tab sample2AGE55



**FULL SAMPLE 2A: DATA FOR 2006 through 2012 with DATA ON EA PGRS, N=12,090****

capture drop sample2a
gen sample2a=1 if E4_AD_IGAP13~=.
replace sample2a=0 if sample2a~=1

tab sample2a


**FULL SAMPLE 2B: DATA FOR 2006 through 2012 with DATA ON AA PGRS, N=3,100****

capture drop sample2b
gen sample2b=1 if A4_AD_IGAP13~=.
replace sample2b=0 if sample2b~=1

tab sample2b


**FULL SAMPLE 3A: DATA FOR  DATA ON EA PGRS, AGE 55+ in 2008, N=9,207 of 12,090**

capture drop sample3a
gen sample3a=1 if sample2AGE55==1 & E4_AD_IGAP13~=.
replace sample3a=0 if sample3a~=1

tab sample3a



**FULL SAMPLE 3B: DATA  ON EA PGRS, AGE 55+ in 2008, N=1,593 of 3,100**

capture drop sample3b
gen sample3b=1 if sample2AGE55==1 & A4_AD_IGAP13~=.
replace sample3b=0 if sample3b~=1

tab sample3b

**FULL SAMPLE 4: DATA for PGRS FOR BOTH RACE GROUPS, N=10,800**

capture drop sample4
gen sample4=.
replace sample4=1 if sample3a==1 | sample3b==1
replace sample4=0 if sample4~=1

tab sample4


**SAMPLE 5: FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2006 or 2008, N=10,421***

capture drop sample5
gen sample5=.
replace sample5=1 if sample4==1 &  MEMORY_PROB_2008==0 
replace sample5=0 if sample5~=1

tab sample5

//////////////////////AD CASES/////////////////////////////



**SAMPLE5A2010: INCIDENT CASES IN 2010 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in  2008, N=79

capture drop sample5a2010
gen sample5a2010=.
replace sample5a2010=1 if sample5==1 & AD_2010==1
replace sample5a2010=0 if sample5a2010~=1

tab sample5a2010


**SAMPLE5A2012: INCIDENT CASES IN 2012 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=79

capture drop sample5a2012
gen sample5a2012=.
replace sample5a2012=1 if sample5==1 & AD_2012==1 & AD_2010==0
replace sample5a2012=0 if sample5a2012~=1

tab sample5a2012

**SAMPLE5A2014: INCIDENT CASES IN 2014 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=79

capture drop sample5a2014
gen sample5a2014=.
replace sample5a2014=1 if sample5==1 & AD_2014==1 & AD_2010==0 & AD_2012==0
replace sample5a2014=0 if sample5a2014~=1

tab sample5a2014

**SAMPLE5A2016: INCIDENT CASES IN 2016 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=75

capture drop sample5a2016
gen sample5a2016=.
replace sample5a2016=1 if sample5==1 & AD_2016==1 & AD_2010==0 & AD_2012==0 & AD_2014==0
replace sample5a2016=0 if sample5a2016~=1

tab sample5a2016

**SAMPLE5A2018: INCIDENT CASES IN 2018 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=59

capture drop sample5a2018
gen sample5a2018=.
replace sample5a2018=1 if sample5==1 & AD_2018==1 & AD_2010==0 & AD_2012==0 & AD_2014==0 & AD_2016==0
replace sample5a2018=0 if sample5a2018~=1

tab sample5a2018

//////////////////ADRD CASES//////////////////////////////

**SAMPLE5b2010: INCIDENT CASES IN 2010 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in  2008, N=198

capture drop sample5b2010
gen sample5b2010=.
replace sample5b2010=1 if sample5==1 & ADRD_2010==1
replace sample5b2010=0 if sample5b2010~=1

tab sample5b2010


**SAMPLE5b2012: INCIDENT CASES IN 2012 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=209

capture drop sample5b2012
gen sample5b2012=.
replace sample5b2012=1 if sample5==1 & ADRD_2012==1 & ADRD_2010==0
replace sample5b2012=0 if sample5b2012~=1

tab sample5b2012

**SAMPLE5b2014: INCIDENT CASES IN 2014 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=194

capture drop sample5b2014
gen sample5b2014=.
replace sample5b2014=1 if sample5==1 & ADRD_2014==1 & ADRD_2010==0 & ADRD_2012==0
replace sample5b2014=0 if sample5b2014~=1

tab sample5b2014

**SAMPLE5b2016: INCIDENT CASES IN 2016 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=174

capture drop sample5b2016
gen sample5b2016=.
replace sample5b2016=1 if sample5==1 & ADRD_2016==1 & ADRD_2010==0 & ADRD_2012==0 & ADRD_2014==0
replace sample5b2016=0 if sample5b2016~=1

tab sample5b2016

**SAMPLE5b2018: INCIDENT CASES IN 2018 OUT OF FULL SAMPLE4, EXCLUDING PREVALENT MEMORY PROBLEMS  in 2008, N=129

capture drop sample5b2018
gen sample5b2018=.
replace sample5b2018=1 if sample5==1 & ADRD_2018==1 & ADRD_2010==0 & ADRD_2012==0 & ADRD_2014==0 & ADRD_2016==0
replace sample5b2018=0 if sample5b2018~=1

tab sample5b2018





**SAMPLE5A: ALL AD INCIDENT CASES BETWEEN 2010 AND 2018, N=371 new AD cases between 2010 and 2018, n=371 of N=10,421 memory problems-free at baseline**

capture drop sample5a
gen sample5a=.
replace sample5a=1 if sample5a2010==1 | sample5a2012==1 | sample5a2014==1 | sample5a2016==1 | sample5a2018==1
replace sample5a=0 if sample5a~=1

tab sample5a
tab sample5a if sample5==1

capture drop AD_INC_CUM
gen AD_INC_CUM=sample5a if sample5==1

tab AD_INC_CUM




**SAMPLE5B: ALL ADRD INCIDENT CASES BETWEEN 2010 AND 2018, N=371 new ADRD cases between 2010 and 2018, n=903 of N=10,421 memory problems-free at baseline**

capture drop sample5b
gen sample5b=.
replace sample5b=1 if sample5b2010==1 | sample5b2012==1 | sample5b2014==1 | sample5b2016==1 | sample5b2018==1
replace sample5b=0 if sample5b~=1

tab sample5b
tab sample5b if sample5==1

capture drop ADRD_INC_CUM
gen ADRD_INC_CUM=sample5b if sample5==1

tab ADRD_INC_CUM


***FINAL SAMPLE, EA and AA: N=10,421*******

capture drop sample_final

gen sample_final=sample5

save, replace


***GENERATE AGE VARIABLES FOR TIME TO EVENT****

***BASELINE AGE, 2008 END OF WAVE********


su AGE_BASELINE2008 if sample_final==1


***AGE FOR THOSE WHO WERE FOLLOWED UP TILL END OF 2018, AD-FREE AND SURVIVED

capture drop AGE_ENDFOLLOW
gen AGE_ENDFOLLOW=r14agey_e if AD_2018==0 & sample_final==1

su AGE_ENDFOLLOW


***AGE FOR THOSE WHO DIED OR LOST TO FOLLOW-UP BETWEEN 2010 AND 2018, AT EACH YEAR

**2012**
capture drop AGE_LOSTFOLLOW_2012
gen AGE_LOSTFOLLOW_2012=r10agey_e if (inw11==0 | inw12==0 | inw13==0 | inw14==0) & AD_2010==0 & sample_final==1 

su AGE_LOSTFOLLOW_2012 if sample_final==1

**2014**
capture drop AGE_LOSTFOLLOW_2014
gen AGE_LOSTFOLLOW_2014=r11agey_e if (inw12==0 | inw13==0 | inw14==0) & AD_2012==0 & sample_final==1 

su AGE_LOSTFOLLOW_2014 if sample_final==1

**2016**

capture drop AGE_LOSTFOLLOW_2016
gen AGE_LOSTFOLLOW_2016=r12agey_e if (inw13==0 | inw14==0) & AD_2014==0 & sample_final==1 

su AGE_LOSTFOLLOW_2016 if sample_final==1

**2018**
capture drop AGE_LOSTFOLLOW_2018
gen AGE_LOSTFOLLOW_2018=r13agey_e if inw14==0 & AD_2016==0 & sample_final==1 

su AGE_LOSTFOLLOW_2018 if sample_final==1



***AGE FOR THOSE WHO HAD INCIDENT AD CASES BETWEEN 2010 AND 2018, AT EACH YEAR

**2010**
capture drop AGE_AD_2010
gen AGE_AD_2010=r10agey_e if AD_2010==1 & sample_final==1

su AGE_AD_2010

 
**2012**
capture drop AGE_AD_2012
gen AGE_AD_2012=r11agey_e if AD_2012==1 & AD_2010==0 & sample_final==1

su AGE_AD_2012

 
**2014**
capture drop AGE_AD_2014
gen AGE_AD_2014=r12agey_e if AD_2014==1 & AD_2012==0 & AD_2010==0 & sample_final==1

su AGE_AD_2014

**2016**
capture drop AGE_AD_2016
gen AGE_AD_2016=r13agey_e if AD_2016==1 & AD_2014==0 & AD_2012==0 & AD_2010==0 & sample_final==1

su AGE_AD_2016

**2018**
capture drop AGE_AD_2018
gen AGE_AD_2018=r14agey_e if AD_2018==1 & AD_2016==0 & AD_2014==0 & AD_2012==0 & AD_2010==0 & sample_final==1

su AGE_AD_2018
 
///////////////////////AGE AT EXIT VARIABLE//////////////////////////////

capture drop AGE_EXIT_AD
gen AGE_EXIT_AD=.
replace AGE_EXIT_AD=AGE_AD_2010 if AD_2010==1 & sample_final==1
replace AGE_EXIT_AD=AGE_AD_2012 if AD_2012==1 & AD_2010==0 & sample_final==1
replace AGE_EXIT_AD=AGE_AD_2014 if AD_2014==1 & AD_2012==0 & AD_2010==0 & sample_final==1
replace AGE_EXIT_AD=AGE_AD_2016 if AD_2016==1 & AD_2014==0 & AD_2012==0 & AD_2010==0 & sample_final==1
replace AGE_EXIT_AD=AGE_AD_2018 if AD_2018==1 & AD_2016==0 & AD_2014==0 & AD_2012==0 & AD_2010==0 & sample_final==1
replace AGE_EXIT_AD=AGE_ENDFOLLOW if AD_2018==0 & sample_final==1 
replace AGE_EXIT_AD=AGE_LOSTFOLLOW_2012 if (inw11==0 | inw12==0 | inw13==0 | inw14==0) & AD_2010==0 & sample_final==1 
replace AGE_EXIT_AD=AGE_LOSTFOLLOW_2014 if (inw12==0 | inw13==0 | inw14==0 ) & AD_2012==0 & sample_final==1  
replace AGE_EXIT_AD=AGE_LOSTFOLLOW_2016 if (inw13==0 | inw14==0) & AD_2014==0 & sample_final==1  
replace AGE_EXIT_AD=AGE_LOSTFOLLOW_2018 if inw14==0 & AD_2016==0 & sample_final==1  
replace AGE_EXIT_AD=r14agey_e if AGE_EXIT_AD==. & sample_final==1 & inw14==1
replace AGE_EXIT_AD=r13agey_e if AGE_EXIT_AD==. & sample_final==1 & inw13==1 & inw14==0
replace AGE_EXIT_AD=r12agey_e if AGE_EXIT_AD==. & sample_final==1 & inw12==1 & inw13==0
replace AGE_EXIT_AD=r11agey_e if AGE_EXIT_AD==. & sample_final==1 & inw11==1 & inw12==0
replace AGE_EXIT_AD=r10agey_e if AGE_EXIT_AD==. & sample_final==1 & inw10==1 & inw11==0
replace AGE_EXIT_AD=r9agey_e if AGE_EXIT_AD==. & sample_final==1 & inw9==1 & inw10==0

save, replace





***AGE FOR THOSE WHO HAD INCIDENT ADRD CASES BETWEEN 2010 AND 2018, AT EACH YEAR

**2010**
capture drop AGE_ADRD_2010
gen AGE_ADRD_2010=r10agey_e if ADRD_2010==1 & sample_final==1

su AGE_ADRD_2010

 
**2012**
capture drop AGE_ADRD_2012
gen AGE_ADRD_2012=r11agey_e if ADRD_2012==1 & ADRD_2010==0 & sample_final==1

su AGE_ADRD_2012

 
**2014**
capture drop AGE_ADRD_2014
gen AGE_ADRD_2014=r12agey_e if ADRD_2014==1 & ADRD_2012==0 & ADRD_2010==0 & sample_final==1

su AGE_ADRD_2014

**2016**
capture drop AGE_ADRD_2016
gen AGE_ADRD_2016=r13agey_e if ADRD_2016==1 & ADRD_2014==0 & ADRD_2012==0 & ADRD_2010==0 & sample_final==1

su AGE_ADRD_2016

**2018**
capture drop AGE_ADRD_2018
gen AGE_ADRD_2018=r14agey_e if ADRD_2018==1 & ADRD_2016==0 & ADRD_2014==0 & ADRD_2012==0 & ADRD_2010==0 & sample_final==1

su AGE_ADRD_2018
 
///////////////////////AGE AT EXIT VARIABLE//////////////////////////////

capture drop AGE_EXIT_ADRD
gen AGE_EXIT_ADRD=.
replace AGE_EXIT_ADRD=AGE_ADRD_2010 if ADRD_2010==1 & sample_final==1
replace AGE_EXIT_ADRD=AGE_ADRD_2012 if ADRD_2012==1 & ADRD_2010==0 & sample_final==1
replace AGE_EXIT_ADRD=AGE_ADRD_2014 if ADRD_2014==1 & ADRD_2012==0 & ADRD_2010==0 & sample_final==1
replace AGE_EXIT_ADRD=AGE_ADRD_2016 if ADRD_2016==1 & ADRD_2014==0 & ADRD_2012==0 & ADRD_2010==0 & sample_final==1
replace AGE_EXIT_ADRD=AGE_ADRD_2018 if ADRD_2018==1 & ADRD_2016==0 & ADRD_2014==0 & ADRD_2012==0 & ADRD_2010==0 & sample_final==1
replace AGE_EXIT_ADRD=AGE_ENDFOLLOW if ADRD_2018==0 & sample_final==1 
replace AGE_EXIT_ADRD=AGE_LOSTFOLLOW_2012 if (inw11==0 | inw12==0 | inw13==0 | inw14==0) & ADRD_2010==0 & sample_final==1 
replace AGE_EXIT_ADRD=AGE_LOSTFOLLOW_2014 if (inw12==0 | inw13==0 | inw14==0 ) & ADRD_2012==0 & sample_final==1  
replace AGE_EXIT_ADRD=AGE_LOSTFOLLOW_2016 if (inw13==0 | inw14==0) & ADRD_2014==0 & sample_final==1  
replace AGE_EXIT_ADRD=AGE_LOSTFOLLOW_2018 if inw14==0 & ADRD_2016==0 & sample_final==1  
replace AGE_EXIT_ADRD=r14agey_e if AGE_EXIT_ADRD==. & sample_final==1 & inw14==1
replace AGE_EXIT_ADRD=r13agey_e if AGE_EXIT_ADRD==. & sample_final==1 & inw13==1 & inw14==0
replace AGE_EXIT_ADRD=r12agey_e if AGE_EXIT_ADRD==. & sample_final==1 & inw12==1 & inw13==0
replace AGE_EXIT_ADRD=r11agey_e if AGE_EXIT_ADRD==. & sample_final==1 & inw11==1 & inw12==0
replace AGE_EXIT_ADRD=r10agey_e if AGE_EXIT_ADRD==. & sample_final==1 & inw10==1 & inw11==0
replace AGE_EXIT_ADRD=r9agey_e if AGE_EXIT_ADRD==. & sample_final==1 & inw9==1 & inw10==0

save, replace



/////////////////////SURVIVAL ANALYSIS DECLARATION///////////////////////


stset AGE_EXIT_AD, failure(AD_INC_CUM==1) time0(AGE_BASELINE2008) scale(1) id(HHIDPN) if(sample_final==1)

stcox E4_01AD2WA_IGAP19 if sample_final==1
stcox A4_01AD2WA_IGAP19 if sample_final==1

tab sample_final


stset AGE_EXIT_ADRD, failure(ADRD_INC_CUM==1) time0(AGE_BASELINE2008) scale(1) id(HHIDPN) if(sample_final==1)

stcox E4_01AD2WA_IGAP19 if sample_final==1
stcox A4_01AD2WA_IGAP19 if sample_final==1

tab sample_final

///////////////////FINAL SAMPLE: N=9,683 of 10,420//////////

capture drop sample_final2
gen sample_final2=.
replace sample_final2=_st if ragender~=.

tab sample_final2
tab AD_INC_CUM if sample_final2==1
tab ADRD_INC_CUM if sample_final2==1


////////////////////MAIN EXPOSURE VARIABLE FOR BOTH RACE GROUPS COMBINED/////////////////

capture drop EA4_01AD2WA_IGAP19
gen EA4_01AD2WA_IGAP19=.
replace EA4_01AD2WA_IGAP19=E4_01AD2WA_IGAP19 if rarace==1
replace EA4_01AD2WA_IGAP19=A4_01AD2WA_IGAP19 if rarace==2

su EA4_01AD2WA_IGAP19

su EA4_01AD2WA_IGAP19 if sample_final2==1


stcox EA4_01AD2WA_IGAP19 if sample_final2==1
stcox c.EA4_01AD2WA_IGAP19 rarace r9agey_e ragender raeduc if sample_final2==1




///////////////////OTHER POLYGENIC RISK SCORES: BOTH RACE GROUPS/////////////////////////

corr EA4_01AD2WA_IGAP19 E4_BMI2_GIANT18  E4_WHR_GIANT15 E4_EVRSMK_TAG10  E4_CANNABIS_ICC18 E4_NEUROT_SSGAC16 E4_WELLB_SSGAC16 E4_BIP_PGC11 E4_CD_CARDIOGRAM11 E4_CORT_CORNET14 E4_T2D_DIAGRAM12 E4_ADHD_PGC17 E4_MDD2_PGC18 E4_EXTRAVER_GPC16 E4_AUTISM_PGC17 E4_LONG_CHARGE15 E4_AB_BROAD17 E4_EDU3_SSGAC18 E4_OCD_IOCDF17 E4_NEBC_SOCGEN16 E4_PTSDC_PGC18 E4_HDL_GLGC13 E4_LDL_GLGC13 E4_ANXCC_ANGST16 E4_CKDTE_CKDGEN19 E4_HTN_COGENT17 E4_ALC_PGC18 E4_PP_COGENT17 E4_HBA1CEA_MAGIC17 E4_GCOG2_CHARGE18 



factor EA4_01AD2WA_IGAP19 E4_BMI2_GIANT18  E4_WHR_GIANT15 E4_EVRSMK_TAG10  E4_CANNABIS_ICC18 E4_NEUROT_SSGAC16 E4_WELLB_SSGAC16 E4_BIP_PGC11 E4_CD_CARDIOGRAM11 E4_CORT_CORNET14 E4_T2D_DIAGRAM12 E4_ADHD_PGC17 E4_MDD2_PGC18 E4_EXTRAVER_GPC16 E4_AUTISM_PGC17 E4_LONG_CHARGE15 E4_AB_BROAD17 E4_EDU3_SSGAC18 E4_OCD_IOCDF17 E4_NEBC_SOCGEN16 E4_PTSDC_PGC18 E4_HDL_GLGC13 E4_LDL_GLGC13 E4_ANXCC_ANGST16 E4_CKDTE_CKDGEN19 E4_HTN_COGENT17 E4_ALC_PGC18 E4_PP_COGENT17 E4_HBA1CEA_MAGIC17 E4_GCOG2_CHARGE18, factors(3)

rotate

           
/////29 POLYGENIC RISK SCORES, 30 with AD//////
		   
		   
**BMI**
su E4_BMI2_GIANT18
su A4_BMI2_GIANT18

capture drop EA4_BMI2_GIANT18
gen EA4_BMI2_GIANT18=.
replace EA4_BMI2_GIANT18=E4_BMI2_GIANT18 if raracem==1
replace EA4_BMI2_GIANT18=A4_BMI2_GIANT18 if raracem==2




**WHR**
su E4_WHR_GIANT15 
su A4_WHR_GIANT15

capture drop EA4_WHR_GIANT15
gen EA4_WHR_GIANT15=.
replace EA4_WHR_GIANT15=E4_WHR_GIANT15 if raracem==1
replace EA4_WHR_GIANT15=A4_WHR_GIANT15 if raracem==2



**HEIGHT**
su E4_HEIGHT2_GIANT18
su A4_HEIGHT2_GIANT18

capture drop EA4_HEIGHT2_GIANT18
gen EA4_HEIGHT2_GIANT18=.
replace EA4_HEIGHT2_GIANT18=E4_HEIGHT2_GIANT18 if raracem==1
replace EA4_HEIGHT2_GIANT18=A4_HEIGHT2_GIANT18 if raracem==2


**SMOKING**
su E4_EVRSMK_TAG10
su A4_EVRSMK_TAG10

capture drop EA4_EVRSMK_TAG10
gen EA4_EVRSMK_TAG10=.
replace EA4_EVRSMK_TAG10=E4_EVRSMK_TAG10 if raracem==1
replace EA4_EVRSMK_TAG10=A4_EVRSMK_TAG10 if raracem==2




**CANNABIS USE**
su E4_CANNABIS_ICC18
su A4_CANNABIS_ICC18

capture drop EA4_CANNABIS_ICC18
gen EA4_CANNABIS_ICC18=.
replace EA4_CANNABIS_ICC18=E4_CANNABIS_ICC18 if raracem==1
replace EA4_CANNABIS_ICC18=A4_CANNABIS_ICC18 if raracem==2


**NEUROTICISM**
su E4_NEUROT_SSGAC16 
su A4_NEUROT_SSGAC16 


capture drop EA4_NEUROT_SSGAC16
gen EA4_NEUROT_SSGAC16=.
replace EA4_NEUROT_SSGAC16=E4_NEUROT_SSGAC16 if raracem==1
replace EA4_NEUROT_SSGAC16=A4_NEUROT_SSGAC16 if raracem==2


**GENERAL WELL-BEING**
su E4_WELLB_SSGAC16
su A4_WELLB_SSGAC16

capture drop EA4_WELLB_SSGAC16
gen EA4_WELLB_SSGAC16=.
replace EA4_WELLB_SSGAC16=E4_WELLB_SSGAC16 if raracem==1
replace EA4_WELLB_SSGAC16=A4_WELLB_SSGAC16 if raracem==2

**BIOPOLAR DISORDER**
su E4_BIP_PGC11
su A4_BIP_PGC11


capture drop EA4_BIP_PGC11
gen EA4_BIP_PGC11=.
replace EA4_BIP_PGC11=E4_BIP_PGC11 if raracem==1
replace EA4_BIP_PGC11=A4_BIP_PGC11 if raracem==2


**CORONARY HEART DISEASE**
su E4_CD_CARDIOGRAM11
su A4_CD_CARDIOGRAM11

capture drop EA4_CD_CARDIOGRAM11
gen EA4_CD_CARDIOGRAM11=.
replace EA4_CD_CARDIOGRAM11=E4_CD_CARDIOGRAM11 if raracem==1
replace EA4_CD_CARDIOGRAM11=A4_CD_CARDIOGRAM11 if raracem==2



**CORTISOL**
su E4_CORT_CORNET14
su A4_CORT_CORNET14

capture drop EA4_CORT_CORNET14
gen EA4_CORT_CORNET14=.
replace EA4_CORT_CORNET14=E4_CORT_CORNET14 if raracem==1
replace EA4_CORT_CORNET14=A4_CORT_CORNET14 if raracem==2



**TYPE 2 DIABETES**
su E4_T2D_DIAGRAM12
su A4_T2D_DIAGRAM12

capture drop EA4_T2D_DIAGRAM12
gen EA4_T2D_DIAGRAM12=.
replace EA4_T2D_DIAGRAM12=E4_T2D_DIAGRAM12 if raracem==1
replace EA4_T2D_DIAGRAM12=A4_T2D_DIAGRAM12 if raracem==2


**ADHD**
su E4_ADHD_PGC17
su A4_ADHD_PGC17


capture drop EA4_ADHD_PGC17
gen EA4_ADHD_PGC17=.
replace EA4_ADHD_PGC17=E4_ADHD_PGC17 if raracem==1
replace EA4_ADHD_PGC17=A4_ADHD_PGC17 if raracem==2

**MDD**
su E4_MDD2_PGC18
su A4_MDD2_PGC18


capture drop EA4_MDD2_PGC18
gen EA4_MDD2_PGC18=.
replace EA4_MDD2_PGC18=E4_MDD2_PGC18 if raracem==1
replace EA4_MDD2_PGC18=A4_MDD2_PGC18 if raracem==2


**EXTRAVERSION**
su E4_EXTRAVER_GPC16
su A4_EXTRAVER_GPC16

capture drop EA4_EXTRAVER_GPC16
gen EA4_EXTRAVER_GPC16=.
replace EA4_EXTRAVER_GPC16=E4_EXTRAVER_GPC16 if raracem==1
replace EA4_EXTRAVER_GPC16=A4_EXTRAVER_GPC16 if raracem==2


**AUTISM**
su E4_AUTISM_PGC17
su A4_AUTISM_PGC17


capture drop EA4_AUTISM_PGC17
gen EA4_AUTISM_PGC17=.
replace EA4_AUTISM_PGC17=E4_AUTISM_PGC17 if raracem==1
replace EA4_AUTISM_PGC17=A4_AUTISM_PGC17 if raracem==2

**LONGEVITY**
su E4_LONG_CHARGE15
su A4_LONG_CHARGE15

capture drop EA4_LONG_CHARGE15
gen EA4_LONG_CHARGE15=.
replace EA4_LONG_CHARGE15=E4_LONG_CHARGE15 if raracem==1
replace EA4_LONG_CHARGE15=A4_LONG_CHARGE15 if raracem==2


**ANTI-SOCIAL BEHAVIOR**
su E4_AB_BROAD17
su A4_AB_BROAD17


capture drop EA4_AB_BROAD17
gen EA4_AB_BROAD17=.
replace EA4_AB_BROAD17=E4_AB_BROAD17 if raracem==1
replace EA4_AB_BROAD17=A4_AB_BROAD17 if raracem==2


**EDUCATIONAL ATTAINMENT**
su E4_EDU3_SSGAC18
su A4_EDU3_SSGAC18


capture drop EA4_EDU3_SSGAC18
gen EA4_EDU3_SSGAC18=.
replace EA4_EDU3_SSGAC18=E4_EDU3_SSGAC18 if raracem==1
replace EA4_EDU3_SSGAC18=A4_EDU3_SSGAC18 if raracem==2


**OCD**
su E4_OCD_IOCDF17
su A4_OCD_IOCDF17


capture drop EA4_OCD_IOCDF17
gen EA4_OCD_IOCDF17=.
replace EA4_OCD_IOCDF17=E4_OCD_IOCDF17 if raracem==1
replace EA4_OCD_IOCDF17=A4_OCD_IOCDF17 if raracem==2


**NUMBER OF CHILDREN BORN**
su E4_NEBC_SOCGEN16
su A4_NEBC_SOCGEN16


capture drop EA4_NEBC_SOCGEN16
gen EA4_NEBC_SOCGEN16=.
replace EA4_NEBC_SOCGEN16=E4_NEBC_SOCGEN16 if raracem==1
replace EA4_NEBC_SOCGEN16=A4_NEBC_SOCGEN16 if raracem==2



**PTSD**
su E4_PTSDC_PGC18
su A4_PTSDC_PGC18

capture drop EA4_PTSDC_PGC18
gen EA4_PTSDC_PGC18=.
replace EA4_PTSDC_PGC18=E4_PTSDC_PGC18 if raracem==1
replace EA4_PTSDC_PGC18=A4_PTSDC_PGC18 if raracem==2


**HDL**
su E4_HDL_GLGC13
su A4_HDL_GLGC13

capture drop EA4_HDL_GLGC13
gen EA4_HDL_GLGC13=.
replace EA4_HDL_GLGC13=E4_HDL_GLGC13 if raracem==1
replace EA4_HDL_GLGC13=A4_HDL_GLGC13 if raracem==2


**LDL**
su E4_LDL_GLGC13
su A4_LDL_GLGC13


capture drop EA4_LDL_GLGC13
gen EA4_LDL_GLGC13=.
replace EA4_LDL_GLGC13=E4_LDL_GLGC13 if raracem==1
replace EA4_LDL_GLGC13=A4_LDL_GLGC13 if raracem==2


**ANXIETY CASE-CONTROL**
su E4_ANXCC_ANGST16
su A4_ANXCC_ANGST16

capture drop EA4_ANXCC_ANGST16
gen EA4_ANXCC_ANGST16=.
replace EA4_ANXCC_ANGST16=E4_ANXCC_ANGST16 if raracem==1
replace EA4_ANXCC_ANGST16=A4_ANXCC_ANGST16 if raracem==2

**CKD**
su E4_CKDTE_CKDGEN19
su A4_CKDTE_CKDGEN19


capture drop EA4_CKDTE_CKDGEN19
gen EA4_CKDTE_CKDGEN19=.
replace EA4_CKDTE_CKDGEN19=E4_CKDTE_CKDGEN19 if raracem==1
replace EA4_CKDTE_CKDGEN19=A4_CKDTE_CKDGEN19 if raracem==2



**HYPERTENSION**
su  E4_HTN_COGENT17
su  A4_HTN_COGENT17


capture drop EA4_HTN_COGENT17
gen EA4_HTN_COGENT17=.
replace EA4_HTN_COGENT17=E4_HTN_COGENT17 if raracem==1
replace EA4_HTN_COGENT17=A4_HTN_COGENT17 if raracem==2


**ALCOHOL DEPENDENCE**
su E4_ALC_PGC18
su A4_ALC_PGC18


capture drop EA4_ALC_PGC18
gen EA4_ALC_PGC18=.
replace EA4_ALC_PGC18=E4_ALC_PGC18 if raracem==1
replace EA4_ALC_PGC18=A4_ALC_PGC18 if raracem==2



**PULSE PRESSURE**
su E4_PP_COGENT17
su A4_PP_COGENT17


capture drop EA4_PP_COGENT17
gen EA4_PP_COGENT17=.
replace EA4_PP_COGENT17=E4_PP_COGENT17 if raracem==1
replace EA4_PP_COGENT17=A4_PP_COGENT17 if raracem==2




**HBA1C**
su E4_HBA1CEA_MAGIC17
su A4_HBA1CEA_MAGIC17


capture drop EA4_HBA1CEA_MAGIC17
gen EA4_HBA1CEA_MAGIC17=.
replace EA4_HBA1CEA_MAGIC17=E4_HBA1CEA_MAGIC17 if raracem==1
replace EA4_HBA1CEA_MAGIC17=A4_HBA1CEA_MAGIC17 if raracem==2



**GENERAL COGNITION**
su E4_GCOG2_CHARGE18
su A4_GCOG2_CHARGE18


capture drop EA4_GCOG2_CHARGE18
gen EA4_GCOG2_CHARGE18=.
replace EA4_GCOG2_CHARGE18=E4_GCOG2_CHARGE18 if raracem==1
replace EA4_GCOG2_CHARGE18=A4_GCOG2_CHARGE18 if raracem==2


save, replace


///////////////////////////////////FULL MODEL WITH POLYGENIC RISK SCORES, AGE, SEX AND RACE//////////////////////////////

stcox EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 raracem ragender r9agey_e


/////////////////OTHER COVARIATES: WEDNESDAY/////////////////////////////////////////////////////////


**Age (years) in 2008**

capture drop AGE2008
gen AGE2008=r9agey_e

su AGE2008 if sample_final2==1,det

capture drop AGE2008br
gen AGE2008br=.
replace AGE2008br=1 if AGE2008>=50 & AGE2008<65
replace AGE2008br=2 if AGE2008>=65 & AGE2008<80
replace AGE2008br=3 if AGE2008>=80 & AGE2008~=.

tab AGE2008br if sample_final2==1


**SEX: 1: Male; 2:Female**

capture drop SEX
gen SEX=ragender

tab SEX if sample_final2==1


/*Birth cohort, no missing data in final sample*/


tab hacohort, missing

tab racohbyr, missing


capture drop birth_cohort
gen birth_cohort = .
replace birth_cohort = 1 if (racohbyr == 1 | racohbyr == 2 | racohbyr == 3)
replace birth_cohort = 2 if (racohbyr == 4)
replace birth_cohort = 3 if (racohbyr == 5)
replace birth_cohort = 4 if (racohbyr == 6)
replace birth_cohort = 5 if (racohbyr == 7)
replace birth_cohort = 99 if (racohbyr == 0 | racohbyr == . | racohbyr == .m)


tab birth_cohort, missing

recode birth_cohort (99=.)

save, replace

tab birth_cohort if sample_final2==1, missing


**RACE: need to impute, n=5 missing**

capture drop RACE
gen RACE=rarace

tab RACE if sample_final2==1

**Ethnicity: 1=Hispanic, 0=Non-Hispanic: n=1 missing

capture drop ETHNICITY
gen ETHNICITY=rahispan

tab ETHNICITY if sample_final2==1

**RACE/ETHNICITY: 

capture drop RACE_ETHN
gen RACE_ETHN=.
replace RACE_ETHN=1 if RACE==1 & ETHNICITY==0
replace RACE_ETHN=2 if RACE==2 & ETHNICITY==0
replace RACE_ETHN=3 if ETHNICITY==1 & RACE~=.
replace RACE_ETHN=4 if RACE==3 & ETHNICITY==0

tab RACE_ETHN if sample_final2==1,missing
tab RACE_ETHN if sample_final2==1


**Marital Status, 2008,  n=18 missing**

tab r9mstat, missing

capture drop marital_2008
gen marital_2008 = .
replace marital_2008 = 1 if r9mstat == 8 /*never married*/
replace marital_2008 = 2 if (r9mstat == 1 | r9mstat == 2 | r9mstat == 3) /*married / partnered*/
replace marital_2008 = 3 if (r9mstat == 4 | r9mstat == 5 | r9mstat == 6) /*separated / divorced*/
replace marital_2008 = 4 if (r9mstat == 7) /*widowed*/

tab marital_2008 if sample_final2==1, missing
tab marital_2008 if sample_final2==1



**EDUCATION: need to impute, n=1 mssing**

tab raeduc, missing 

capture drop education
gen education = .
replace education = 1 if raeduc == 1 /*< HS*/
replace education = 2 if raeduc == 2 /*GED*/
replace education = 3 if raeduc == 3 /*HS GRADUATE*/
replace education = 4 if raeduc == 4 /*SOME COLLEGE*/
replace education = 5 if raeduc == 5 /*COLLEGE AND ABOVE*/

tab education if sample_final2, missing
tab education if sample_final2


**work status*, n=20 missing**
**0.not working for pay
**    1.working for pay


tab r9work, missing

capture drop work_st_2008
gen work_st_2008 = .
replace work_st_2008 = 0 if r9work == 0
replace work_st_2008 = 1 if r9work == 1

tab work_st_2008, missing
tab work_st_2008 if sample_final2, missing
tab work_st_2008 if sample_final2

***Federal health insurance, n=26 missing***
**0=no, 1=yes**

tab r9higov, missing

capture drop fhi_2008
gen fhi_2008 = .
replace fhi_2008 = 0 if r9higov == 0
replace fhi_2008 = 1 if r9higov == 1

tab fhi_2008, missing
tab fhi_2008 if sample_final2==1, missing
tab fhi_2008 if sample_final2==1


/*Number of household members, 2008, n=17 missing*/

tab h9hhres, missing

capture drop housmemnum_2008
gen housmemnum_2008 = .
replace housmemnum_2008 = h9hhres if h9hhres ~= .

tab  housmemnum_2008, missing

capture drop housmemnum_br_2008
gen housmemnum_br_2008 = .
replace housmemnum_br_2008 = 1 if housmemnum_2008 <= 3 /*<= 3*/
replace housmemnum_br_2008 = 2 if housmemnum_2008 > 3 & housmemnum_2008 ~= . /*> 3*/

tab  housmemnum_br_2008, missing
tab  housmemnum_br_2008 if sample_final2==1, missing
tab  housmemnum_br_2008 if sample_final2==1

**//Total wealth, 2008, n=17 missing//


tab h9itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2008
gen totwealth_2008 = .
replace totwealth_2008 = 1 if h9itot < 25000
replace totwealth_2008 = 2 if h9itot >= 25000 & h9itot < 125000
replace totwealth_2008 = 3 if h9itot >= 125000 & h9itot < 300000
replace totwealth_2008 = 4 if h9itot >= 300000 & h9itot < 650000
replace totwealth_2008 = 5 if h9itot >= 650000 & h9itot ~= .


tab totwealth_2008, missing
tab totwealth_2008 if sample_final2==1, missing
tab totwealth_2008 if sample_final2==1

save, replace

**Region of residence, n=17 missing**

tab r9cenreg, missing

capture drop regres_2008
gen regres_2008 = r9cenreg if (r9cenreg ~= . &  r9cenreg ~= .m)

tab regres_2008, missing
tab regres_2008 if sample_final2==1, missing
tab regres_2008 if sample_final2==1

save, replace

**Smoking, (never smoker, past smoker, current smoker), 2008, n=33 missing**

tab r9smokev, missing
tab r9smoken, missing

capture drop smoking_2008
gen smoking_2008 = .
replace smoking_2008 = 1 if r9smokev == 0
replace smoking_2008 = 2 if r9smokev == 1 & r9smoken == 0
replace smoking_2008 = 3 if r9smokev == 1 & r9smoken == 1

tab smoking_2008, missing
tab smoking_2008 if sample_final2==1, missing
tab smoking_2008 if sample_final2==1

save, replace



*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2008*, n=173 missing/

tab r9drink, missing
tab r9drinkd, missing


capture drop alcohol_2008
gen alcohol_2008 = .
replace alcohol_2008 = 1 if r9drink == 0
replace alcohol_2008 = 2 if r9drink == 1 & r9drinkd == 0
replace alcohol_2008 = 3 if r9drink == 1 & (r9drinkd == 1 | r9drinkd == 2)
replace alcohol_2008 = 4 if r9drink == 1 & (r9drinkd > 3 & r9drinkd ~= . & r9drinkd ~= .d & r9drinkd ~= .m & r9drinkd ~= .r)

tab alcohol_2008, missing
tab alcohol_2008 if sample_final2==1, missing
tab alcohol_2008 if sample_final2==1



/*physical exercise, n=17 missing*/

***  Never
**  1-4 times per month
**  > 1 times per week



/*2008*/


tab r9vgactx, missing
tab r9mdactx, missing

capture drop physic_act_2008
gen physic_act_2008 = .
replace physic_act_2008 = 1 if (r9vgactx ==  5 & r9mdactx == 5)
replace physic_act_2008 = 2 if (r9vgactx ==  3 | r9mdactx == 3 | r9vgactx ==  4 | r9mdactx == 4)
replace physic_act_2008 = 3 if (r9vgactx ==  1 | r9mdactx == 1 | r9vgactx ==  2 | r9mdactx == 2)

tab physic_act_2008, missing
tab physic_act_2008 if sample_final2==1, missing
tab physic_act_2008 if sample_final2==1


/*HEALTH*/

/*body mass index, n=41 missing*/

/*2008*/

/*<25 
  25-29.9
  ≥30
*/

tab r9pmbmi, missing
tab r9bmi, missing
tab r9bmi if sample_final2==1, missing
tab r9bmi if sample_final2==1
su r9bmi if sample_final2==1,det


capture drop bmi_2008
gen bmi_2008 = r9pmbmi if r9pmbmi < 100
else replace bmi_2008 = r9bmi if r9bmi < 100

tab bmi_2008, missing
tab bmi_2008 if sample_final2==1, missing
tab bmi_2008 if sample_final2==1
su bmi_2008 if sample_final2==1, det



capture drop bmibr_2008
gen bmibr_2008 = 1 if bmi_2008 < 25
replace bmibr_2008 = 2 if bmi_2008 >= 25 & bmi_2008 < 30
replace bmibr_2008 = 3 if bmi_2008 >= 30 & bmi_2008 ~= .

tab bmibr_2008, missing
tab bmibr_2008 if sample_final2==1, missing


/*cardiometabolic risk factors and chronic conditions, 2008, n=27 missing*/

/*HYPERTENSION*/

tab r9hibpe, missing

capture drop hbp_ever_2008
gen hbp_ever_2008 = .
replace hbp_ever_2008 = 0 if r9hibpe == 0
replace hbp_ever_2008 = 1 if r9hibpe == 1

tab hbp_ever_2008, missing
tab hbp_ever_2008 if sample_final2==1, missing
tab hbp_ever_2008 if sample_final2==1


/*DIABETES*/

tab r9diabe, missing

capture drop diab_ever_2008
gen diab_ever_2008 = .
replace diab_ever_2008 = 0 if r9diabe == 0
replace diab_ever_2008 = 1 if r9diabe == 1

tab diab_ever_2008, missing
tab diab_ever_2008 if sample_final2==1, missing
tab diab_ever_2008 if sample_final2==1


/*HEART PROBLEMS*/

tab r9hearte, missing

capture drop heart_ever_2008
gen heart_ever_2008 = .
replace heart_ever_2008 = 0 if r9hearte == 0
replace heart_ever_2008 = 1 if r9hearte == 1

tab heart_ever_2008, missing
tab heart_ever_2008 if sample_final2==1, missing
tab heart_ever_2008 if sample_final2==1


/*STROKE*/

tab r9stroke, missing

capture drop stroke_ever_2008
gen stroke_ever_2008 = .
replace stroke_ever_2008 = 0 if r9stroke == 0
replace stroke_ever_2008 = 1 if r9stroke == 1

tab stroke_ever_2008, missing
tab stroke_ever_2008 if sample_final2==1, missing
tab stroke_ever_2008 if sample_final2==1


/*NUMBER OF CONDITIONS*/

/*  0
    1-2
    ≥ 3
*/

capture drop cardiometcond_2008
gen cardiometcond_2008 = .
replace cardiometcond_2008 = hbp_ever_2008 + diab_ever_2008 + heart_ever_2008 + stroke_ever_2008

tab cardiometcond_2008, missing
tab cardiometcond_2008 if sample_final2==1, missing
tab cardiometcond_2008 if sample_final2==1


capture drop cardiometcondbr_2008
gen cardiometcondbr_2008 = .
replace cardiometcondbr_2008 = 1 if cardiometcond_2008 ==0
replace cardiometcondbr_2008 = 2 if (cardiometcond_2008 == 1 | cardiometcond_2008 == 2)
replace cardiometcondbr_2008 = 3 if (cardiometcond_2008 == 3 | cardiometcond_2008 == 4)

tab cardiometcondbr_2008, missing
tab cardiometcondbr_2008 if sample_final2==1, missing
tab cardiometcondbr_2008 if sample_final2==1

save, replace


/*Self-rated health, 2008, n=17 missing*/

/*   Excellent/very good/good
    Fair/poor 
*/


tab r9shlt, missing

capture drop srh_2008
gen srh_2008 = .
replace srh_2008 = 1 if (r9shlt == 1 | r9shlt == 2 | r9shlt == 3)
replace srh_2008 = 2 if (r9shlt == 4 | r9shlt == 5)

tab srh_2008, missing
tab srh_2008 if sample_final2==1, missing
tab srh_2008 if sample_final2==1



save, replace





/////////////////////SAMPLING DESIGN COMPLEXITY:////////////////////////////////////////////////


**RESPONDENT WEIGHT: lwgtr
**Stratum: stratum
**PSU: secu



//////////////////////MULTIPLE IMPUTATIONS FOR COVARIATES:///////////////////////////////////////


**//RUN IMPUTATIONS FOR 2010 COVARIATE DATA: this week//


**DESIGN VARIABLES**
**svyset secu [pweight=lwgtr], strata(stratum) 

**SAMPLING VARIABLES**
**sample*

**OUTCOME AND OTHER RELATED VARIABLES**
**AD* AGE* _t _st _d _t0

**EXPOSURE AND MEDIATOR VARIABLES**
**EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18

**COVARIATES USED FOR OR REQUIRING IMPUTATION:
**AGE2008 SEX birth_cohort RACE ETHNICITY RACE_ETHN marital_2008 education work_st_2008 fhi_2008 housmemnum_2008 housmemnum_br_2008 totwealth_2008 regres_2008 smoking_2008 alcohol_2008 physic_act_2008 bmi_2008 bmibr_2008 hbp_ever_2008 diab_ever_2008 heart_ever_2008 stroke_ever_2008 cardiometcond_2008 cardiometcondbr_2008 srh_2008

**--> re-compute categorical BMI and cardiometabolic risk variables after imputation

use HRS_PAPER_PGRS_DEMENTIA_FINAL,clear



keep HHIDPN HHID hhid pn lwgtr stratum secu sample* EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18  AD* ADRD* AGE* _t _st _d _t0 AGE2008 SEX birth_cohort RACE ETHNICITY RACE_ETHN marital_2008 education work_st_2008 fhi_2008 housmemnum_2008 housmemnum_br_2008 totwealth_2008 regres_2008 smoking_2008 alcohol_2008 physic_act_2008 bmi_2008 bmibr_2008 hbp_ever_2008 diab_ever_2008 heart_ever_2008 stroke_ever_2008 cardiometcond_2008 cardiometcondbr_2008 srh_2008

save finaldata_unimputed, replace

sort HHIDPN 

save, replace

set matsize 11000

capture mi set, clear

mi set flong

capture mi svyset, clear

mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_AD  [pweight = lwgtr], failure(AD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


mi unregister HHIDPN HHID hhid pn lwgtr stratum secu sample* EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18  AD* AGE* _t _st _d _t0 AGE2008 SEX birth_cohort RACE ETHNICITY RACE_ETHN marital_2008 education work_st_2008 fhi_2008 housmemnum_2008 housmemnum_br_2008 totwealth_2008 regres_2008 smoking_2008 alcohol_2008 physic_act_2008 bmi_2008 bmibr_2008 hbp_ever_2008 diab_ever_2008 heart_ever_2008 stroke_ever_2008 cardiometcond_2008 cardiometcondbr_2008 srh_2008

mi register imputed  AGE2008 SEX birth_cohort RACE ETHNICITY RACE_ETHN marital_2008 education work_st_2008 fhi_2008 housmemnum_2008 housmemnum_br_2008 totwealth_2008 regres_2008 smoking_2008 alcohol_2008 physic_act_2008 bmi_2008 bmibr_2008 hbp_ever_2008 diab_ever_2008 heart_ever_2008 stroke_ever_2008 cardiometcond_2008 cardiometcondbr_2008 srh_2008

mi register passive EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18  AD* AGE* 

tab1 AGE2008 SEX birth_cohort RACE ETHNICITY RACE_ETHN marital_2008 education work_st_2008 fhi_2008 housmemnum_2008 housmemnum_br_2008 totwealth_2008 regres_2008 smoking_2008 alcohol_2008 physic_act_2008 bmi_2008 bmibr_2008 hbp_ever_2008 diab_ever_2008 heart_ever_2008 stroke_ever_2008 cardiometcond_2008 cardiometcondbr_2008 srh_2008 if AGE2008>=55


mi impute chained (mlogit) RACE marital_2008 education work_st_2008  fhi_2008 housmemnum_br_2008 totwealth_2008 regres_2008 smoking_2008 alcohol_2008 physic_act_2008 hbp_ever_2008 diab_ever_2008 heart_ever_2008 stroke_ever_2008 srh_2008 (regress) bmi_2008  = AGE2008 SEX if AGE2008>=55 , force augment noisily  add(5) rseed(1234) savetrace(tracefile, replace) 



save finaldata_imputed, replace


capture log close


////////////////////MAIN ANALYSIS:///////////////////////////////////////////////////////////



//Re-generate covariates that need to be constructed//

use finaldata_imputed,clear


capture mi svyset, clear

mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

capture drop AA
mi passive: gen AA=.
mi passive: replace AA=1 if RACE==2 & RACE_ETHN~=. & sample_final2==1
mi passive: replace AA=0 if RACE==1 & sample_final2==1

capture drop White
mi passive: gen White=.
mi passive: replace White=1 if RACE==1 & sample_final2==1
mi passive: replace White=0 if RACE==2 & sample_final2==1

capture drop male
mi passive: gen male=.
mi passive: replace male=1 if SEX==1 & sample_final2==1
mi passive: replace male=0 if SEX==2 & sample_final2==1

capture drop female
mi passive: gen female=.
mi passive: replace female=1 if SEX==2 & sample_final2==1
mi passive: replace female=0 if SEX==1 & sample_final2==1


capture drop cardiometcond_2008
mi passive: gen cardiometcond_2008 = .
mi passive: replace cardiometcond_2008 = hbp_ever_2008 + diab_ever_2008 + heart_ever_2008 + stroke_ever_2008

save finaldata_imputed_FINAL, replace




***TABLE 1***

capture log close

log using "D:\HRS_PROJ\OUTPUT_FINAL\TABLE1_S1.smcl",replace

use finaldata_imputed_FINAL,clear



**Variable      Storage   Display    Value
**    name         type    format    label      Variable label
**--------------------------------------------------------------------------------------------------
**E4_GWAD2NA_I~19 double  %12.0g                EA ALZHEIMER'S DISEASE 2 PT=1 NO APOE PGS (IGAP
**                                                2019)
**E4_01AD2NA_I~19 double  %12.0g                EA ALZHEIMER'S DISEASE 2 PT=0.01 NO APOE PGS (IGAP
**                                                2019)
**E4_GWAD2WA_I~19 double  %12.0g                EA ALZHEIMER'S DISEASE 2 PT=1 WITH APOE PGS (IGAP
**                                                2019)
**E4_01AD2WA_I~19 double  %12.0g                EA ALZHEIMER'S DISEASE 2 PT=0.01 WITH APOE PGS (IGAP
**                                                2019)
										


************OVERALL STUDY SAMPLE CHARACTERISTICS**********************

****Covariates******

mi estimate: svy, subpop(sample_final2): mean AGE2008

mi estimate: svy, subpop(sample_final2): prop SEX

mi estimate: svy, subpop(sample_final2): prop birth_cohort

mi estimate: svy, subpop(sample_final2): prop RACE

mi estimate: svy, subpop(sample_final2): prop marital_2008

mi estimate: svy, subpop(sample_final2): prop education

mi estimate: svy, subpop(sample_final2): prop work_st_2008

mi estimate: svy, subpop(sample_final2): prop fhi_2008

mi estimate: svy, subpop(sample_final2): prop housmemnum_br_2008

mi estimate: svy, subpop(sample_final2): prop totwealth_2008

mi estimate: svy, subpop(sample_final2): prop smoking_2008

mi estimate: svy, subpop(sample_final2): prop alcohol_2008

mi estimate: svy, subpop(sample_final2): prop physic_act_2008

mi estimate: svy, subpop(sample_final2): mean bmi_2008

mi estimate: svy, subpop(sample_final2): prop hbp_ever_2008

mi estimate: svy, subpop(sample_final2): prop diab_ever_2008

mi estimate: svy, subpop(sample_final2): prop heart_ever_2008

mi estimate: svy, subpop(sample_final2): prop stroke_ever_2008

mi estimate: svy, subpop(sample_final2): mean cardiometcond_2008

mi estimate: svy, subpop(sample_final2): prop srh_2008

save, replace

*****OUTCOMES********
mi estimate: svy, subpop(sample_final2): prop AD_INC_CUM	
	
mi estimate: svy, subpop(sample_final2): prop ADRD_INC_CUM	


*****EXPOSURES AND MEDIATORS/MODERATORS********

foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(sample_final2): mean `z'	
	
}


************MALE STUDY SAMPLE CHARACTERISTICS**********************


****Covariates******

mi estimate: svy, subpop(male): mean AGE2008

mi estimate: svy, subpop(male): prop SEX

mi estimate: svy, subpop(male): prop birth_cohort

mi estimate: svy, subpop(male): prop RACE

mi estimate: svy, subpop(male): prop marital_2008

mi estimate: svy, subpop(male): prop education

mi estimate: svy, subpop(male): prop work_st_2008

mi estimate: svy, subpop(male): prop fhi_2008

mi estimate: svy, subpop(male): prop housmemnum_br_2008

mi estimate: svy, subpop(male): prop totwealth_2008


mi estimate: svy, subpop(male): prop smoking_2008

mi estimate: svy, subpop(male): prop alcohol_2008

mi estimate: svy, subpop(male): prop physic_act_2008

mi estimate: svy, subpop(male): mean bmi_2008

mi estimate: svy, subpop(male): prop hbp_ever_2008

mi estimate: svy, subpop(male): prop diab_ever_2008

mi estimate: svy, subpop(male): prop heart_ever_2008

mi estimate: svy, subpop(male): prop stroke_ever_2008

mi estimate: svy, subpop(male): mean cardiometcond_2008

mi estimate: svy, subpop(male): prop srh_2008

save, replace

*****OUTCOMES********
mi estimate: svy, subpop(male): prop AD_INC_CUM	

mi estimate: svy, subpop(male): prop ADRD_INC_CUM	
	


*****EXPOSURES AND MEDIATORS/MODERATORS********

foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(male): mean `z'	
	
}





************FEMALE STUDY SAMPLE CHARACTERISTICS**********************

****Covariates******

mi estimate: svy, subpop(female): mean AGE2008

mi estimate: svy, subpop(female): prop SEX

mi estimate: svy, subpop(female): prop birth_cohort

mi estimate: svy, subpop(female): prop RACE

mi estimate: svy, subpop(female): prop marital_2008

mi estimate: svy, subpop(female): prop education

mi estimate: svy, subpop(female): prop work_st_2008

mi estimate: svy, subpop(female): prop fhi_2008

mi estimate: svy, subpop(female): prop housmemnum_br_2008

mi estimate: svy, subpop(female): prop totwealth_2008


mi estimate: svy, subpop(female): prop smoking_2008

mi estimate: svy, subpop(female): prop alcohol_2008

mi estimate: svy, subpop(female): prop physic_act_2008

mi estimate: svy, subpop(female): mean bmi_2008

mi estimate: svy, subpop(female): prop hbp_ever_2008

mi estimate: svy, subpop(female): prop diab_ever_2008

mi estimate: svy, subpop(female): prop heart_ever_2008

mi estimate: svy, subpop(female): prop stroke_ever_2008

mi estimate: svy, subpop(female): mean cardiometcond_2008

mi estimate: svy, subpop(female): prop srh_2008

save, replace

*****OUTCOMES********
mi estimate: svy, subpop(female): prop AD_INC_CUM	
mi estimate: svy, subpop(female): prop ADRD_INC_CUM	
	


*****EXPOSURES AND MEDIATORS/MODERATORS********

foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(female): mean `z'	
	
}



************STUDY SAMPLE CHARACTERISTICS BY SEX**********************


****Covariates******

mi estimate: svy, subpop(sample_final2): reg AGE2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit birth_cohort SEX

mi estimate: svy, subpop(sample_final2): mlogit RACE SEX

mi estimate: svy, subpop(sample_final2): mlogit marital_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit education SEX

mi estimate: svy, subpop(sample_final2): mlogit work_st_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit fhi_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit housmemnum_br_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit totwealth_2008 SEX


mi estimate: svy, subpop(sample_final2): mlogit smoking_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit alcohol_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit physic_act_2008 SEX

mi estimate: svy, subpop(sample_final2): reg bmi_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit hbp_ever_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit diab_ever_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit heart_ever_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit stroke_ever_2008 SEX

mi estimate: svy, subpop(sample_final2): reg cardiometcond_2008 SEX

mi estimate: svy, subpop(sample_final2): mlogit srh_2008 SEX

save, replace

*****OUTCOMES********
mi estimate: svy, subpop(sample_final2): logit AD_INC_CUM SEX	
mi estimate: svy, subpop(sample_final2): logit ADRD_INC_CUM SEX	
	


*****EXPOSURES AND MEDIATORS/MODERATORS********

foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(sample_final2): reg `z' SEX	
	
}
	




save,replace


************WHITE STUDY SAMPLE CHARACTERISTICS**********************


****Covariates******

mi estimate: svy, subpop(White): mean AGE2008

mi estimate: svy, subpop(White): prop SEX

mi estimate: svy, subpop(White): prop birth_cohort

mi estimate: svy, subpop(White): prop RACE

mi estimate: svy, subpop(White): prop marital_2008

mi estimate: svy, subpop(White): prop education

mi estimate: svy, subpop(White): prop work_st_2008

mi estimate: svy, subpop(White): prop fhi_2008

mi estimate: svy, subpop(White): prop housmemnum_br_2008

mi estimate: svy, subpop(White): prop totwealth_2008


mi estimate: svy, subpop(White): prop smoking_2008

mi estimate: svy, subpop(White): prop alcohol_2008

mi estimate: svy, subpop(White): prop physic_act_2008

mi estimate: svy, subpop(White): mean bmi_2008

mi estimate: svy, subpop(White): prop hbp_ever_2008

mi estimate: svy, subpop(White): prop diab_ever_2008

mi estimate: svy, subpop(White): prop heart_ever_2008

mi estimate: svy, subpop(White): prop stroke_ever_2008

mi estimate: svy, subpop(White): mean cardiometcond_2008

mi estimate: svy, subpop(White): prop srh_2008

save, replace

*****OUTCOMES********
mi estimate: svy, subpop(White): prop AD_INC_CUM	
mi estimate: svy, subpop(White): prop ADRD_INC_CUM	
	


*****EXPOSURES AND MEDIATORS/MODERATORS********

foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(White): mean `z'	
	
}


************NON-WHITE STUDY SAMPLE CHARACTERISTICS**********************

****Covariates******

mi estimate: svy, subpop(AA): mean AGE2008

mi estimate: svy, subpop(AA): prop SEX

mi estimate: svy, subpop(AA): prop birth_cohort

mi estimate: svy, subpop(AA): prop RACE

mi estimate: svy, subpop(AA): prop marital_2008

mi estimate: svy, subpop(AA): prop education

mi estimate: svy, subpop(AA): prop work_st_2008

mi estimate: svy, subpop(AA): prop fhi_2008

mi estimate: svy, subpop(AA): prop housmemnum_br_2008

mi estimate: svy, subpop(AA): prop totwealth_2008

mi estimate: svy, subpop(AA): prop smoking_2008

mi estimate: svy, subpop(AA): prop alcohol_2008

mi estimate: svy, subpop(AA): prop physic_act_2008

mi estimate: svy, subpop(AA): mean bmi_2008

mi estimate: svy, subpop(AA): prop hbp_ever_2008

mi estimate: svy, subpop(AA): prop diab_ever_2008

mi estimate: svy, subpop(AA): prop heart_ever_2008

mi estimate: svy, subpop(AA): prop stroke_ever_2008

mi estimate: svy, subpop(AA): mean cardiometcond_2008

mi estimate: svy, subpop(AA): prop srh_2008

save, replace

*****OUTCOMES********
mi estimate: svy, subpop(AA): prop AD_INC_CUM	
mi estimate: svy, subpop(AA): prop ADRD_INC_CUM	
	


*****EXPOSURES AND MEDIATORS/MODERATORS********

foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(AA): mean `z'	
	
}



************STUDY SAMPLE CHARACTERISTICS BY AA**********************


****Covariates******

mi estimate: svy, subpop(sample_final2): reg AGE2008 AA

mi estimate: svy, subpop(sample_final2): mlogit birth_cohort AA

mi estimate: svy, subpop(sample_final2): mlogit SEX AA

mi estimate: svy, subpop(sample_final2): mlogit marital_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit education AA

mi estimate: svy, subpop(sample_final2): mlogit work_st_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit fhi_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit housmemnum_br_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit totwealth_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit smoking_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit alcohol_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit physic_act_2008 AA

mi estimate: svy, subpop(sample_final2): reg bmi_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit hbp_ever_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit diab_ever_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit heart_ever_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit stroke_ever_2008 AA

mi estimate: svy, subpop(sample_final2): reg cardiometcond_2008 AA

mi estimate: svy, subpop(sample_final2): mlogit srh_2008 AA

save, replace

*****OUTCOMES********
mi estimate: svy, subpop(sample_final2): logit AD_INC_CUM RACE	
mi estimate: svy, subpop(sample_final2): logit ADRD_INC_CUM RACE	
	


*****EXPOSURES AND MEDIATORS/MODERATORS********

foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(sample_final2): reg `z' RACE	
	
}

save,replace



/////////////////////////////BY SEX, BY RACE, ADJUSTED FOR AGE and SEX/RACE////////////////



************STUDY SAMPLE CHARACTERISTICS BY SEX AA AGE2016**********************


****Covariates******

mi estimate: svy, subpop(sample_final2): reg AGE2008 SEX AA 

mi estimate: svy, subpop(sample_final2): mlogit birth_cohort SEX AA 

mi estimate: svy, subpop(sample_final2): mlogit RACE SEX AGE2008

mi estimate: svy, subpop(sample_final2): mlogit marital_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit education SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit work_st_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit fhi_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit housmemnum_br_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit totwealth_2008 SEX AA AGE2008


mi estimate: svy, subpop(sample_final2): mlogit smoking_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit alcohol_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit physic_act_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): reg bmi_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit hbp_ever_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit diab_ever_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit heart_ever_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit stroke_ever_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): reg cardiometcond_2008 SEX AA AGE2008

mi estimate: svy, subpop(sample_final2): mlogit srh_2008 SEX AA AGE2008

save, replace

*****OUTCOMES********

foreach z of varlist AD_INC_CUM ADRD_INC_CUM {
mi estimate: svy, subpop(sample_final2): logit `z'	SEX AA AGE2008
	
}

///EXPOSURES/MEDIATORS///


foreach z of varlist EA4_01AD2WA_IGAP19 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate: svy, subpop(sample_final2): reg `z' SEX AA AGE2008	
	
}

save,replace

mi unregister AGE_EXIT_AD AGE_BASELINE2008 AD_INC_CUM ADRD_INC_CUM AGE_EXIT_ADRD

save, replace

capture log close


log using "D:\HRS_PROJ\OUTPUT_FINAL\FIGURE2.smcl",replace

**********FIGURE 2: AD POLYGENIC RISK SCORE VS. AD INCIDENCE***************************
use finaldata_imputed_FINAL,clear
 
save, replace 
 
mi stset AGE_EXIT_AD  [pweight = lwgtr], failure(AD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)

mi extract 0

save finaldata_imputed_FINALzero, replace


capture drop EA4_01AD2WA_IGAP19quart
xtile EA4_01AD2WA_IGAP19quart=EA4_01AD2WA_IGAP19 if sample_final2==1,nq(4)

save, replace

sts test EA4_01AD2WA_IGAP19quart

sts test RACE


sts graph,  by(EA4_01AD2WA_IGAP19quart)
sts graph if SEX==1, by(EA4_01AD2WA_IGAP19quart)
sts graph if SEX==2, by(EA4_01AD2WA_IGAP19quart)
sts graph if RACE==1, by(EA4_01AD2WA_IGAP19quart)
sts graph if RACE==2, by(EA4_01AD2WA_IGAP19quart)
sts graph,  by(RACE)

 sts graph, noorigin plotopts(recast(line)) ytitle(Incident AD survival probability) xtitle(Age(years)) title(AD PGS vs. AD) legend(on order(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4")) by(EA4_01AD2WA_IGAP19quart) scheme(sj)
 graph save "FIG2A.gph", replace
 
 sts graph, noorigin plotopts(recast(line)) ytitle(Incident AD survival probability) xtitle(Age(years)) title(RACE vs. AD) legend(on order(1 "White" 2 "AA" )) by(RACE) scheme(sj)
graph save "FIG2B.gph", replace

graph combine "FIG2A.gph" "FIG2B.gph"
graph save "FIG2.gph", replace

save, replace

capture log close


log using "D:\HRS_PROJ\OUTPUT_FINAL\FIGURES1.smcl",replace


**********FIGURE S1: AD POLYGENIC RISK SCORE VS. ADRD INCIDENCE***************************
use finaldata_imputed_FINAL,clear
 
save, replace 
 
mi stset AGE_EXIT_ADRD  [pweight = lwgtr], failure(ADRD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)

mi extract 0

save finaldata_imputed_FINALzero, replace


capture drop EA4_01AD2WA_IGAP19quart
xtile EA4_01AD2WA_IGAP19quart=EA4_01AD2WA_IGAP19 if sample_final2==1,nq(4)

save, replace

sts test EA4_01AD2WA_IGAP19quart

sts test RACE


sts graph,  by(EA4_01AD2WA_IGAP19quart)
sts graph if SEX==1, by(EA4_01AD2WA_IGAP19quart)
sts graph if SEX==2, by(EA4_01AD2WA_IGAP19quart)
sts graph if RACE==1, by(EA4_01AD2WA_IGAP19quart)
sts graph if RACE==2, by(EA4_01AD2WA_IGAP19quart)
sts graph,  by(RACE)

 sts graph, noorigin plotopts(recast(line)) ytitle(Incident ADRD survival probability) xtitle(Age(years)) title(AD PGS vs. ADRD) legend(on order(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4")) by(EA4_01AD2WA_IGAP19quart) scheme(sj)
 graph save "FIGS1A.gph", replace
 
 sts graph, noorigin plotopts(recast(line)) ytitle(Incident ADRD survival probability) xtitle(Age(years)) title(RACE vs. ADRD) legend(on order(1 "White" 2 "AA" )) by(RACE) scheme(sj)
graph save "FIGS1B.gph", replace

graph combine "FIGS1A.gph" "FIGS1B.gph"
graph save "FIGS1.gph", replace


capture log close

log using "D:\HRS_PROJ\OUTPUT_FINAL\TABLE2.smcl",replace


**TABLE 2: AD POLYGENIC RISK SCORE VS. AD INCIDENCE: ADJUSTMENT FOR BASELINE COVARIATES**

use finaldata_imputed_FINAL,clear

****OVERALL*****


mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_AD  [pweight = lwgtr], failure(AD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****INTERACTION OF PGS BY SEX*************************


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.marital_2008 i.housmemnum_br_2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****INTERACTION OF RACE BY SEX*************************


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.marital_2008 i.housmemnum_br_2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****INTERACTION BY RACE*************************


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18



****MEN******


mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_AD  [pweight = lwgtr], failure(AD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008



**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18



***WOMEN*****


mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_AD  [pweight = lwgtr], failure(AD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****WHITES****

mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_AD  [pweight = lwgtr], failure(AD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008

**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008  EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****AFRICAN AMERICANS***

mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_AD  [pweight = lwgtr], failure(AD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18



capture log close

log using "D:\HRS_PROJ\OUTPUT_FINAL\TABLE3.smcl",replace

use finaldata_imputed_FINAL,clear


**TABLE 3**

capture drop marital_2008g* educationg* work_st_2008g* fhi_2008g*  housmemnum_br_2008g* totwealth_2008g* smoking_2008g* alcohol_2008g* physic_act_2008g* srh_2008g*

tab marital_2008,generate(marital_2008g)

tab education, generate(educationg)

tab work_st_2008, generate(work_st_2008g)

tab fhi_2008, generate(fhi_2008g)

tab housmemnum_br_2008, generate(housmemnum_br_2008g)

tab totwealth_2008,generate(totwealth_2008g)

tab smoking_2008, generate(smoking_2008g)

tab alcohol_2008,generate(alcohol_2008g)

tab physic_act_2008,generate(physic_act_2008g)

tab srh_2008,generate(srh_2008g)

save, replace

/////////////////REDUCED MODEL//////////////////////////


foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA  if sample_final2==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}



foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA  if male==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}




foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA  if female==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}


foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA if White==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}


foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA if AA==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}

capture log close



log using "D:\HRS_PROJ\OUTPUT_FINAL\TABLES2.smcl",replace

use finaldata_imputed_FINAL,clear

//////////////////////////////////////////////////ADRD INCIDENCE TABLES///////////////////////////////////////////////////////

**TABLE S2: AD POLYGENIC RISK SCORE VS. ADRD INCIDENCE: ADJUSTMENT FOR BASELINE COVARIATES**


****OVERALL*****


mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_ADRD  [pweight = lwgtr], failure(ADRD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18

****INTERACTION OF PGS BY SEX*************************


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##SEX RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****INTERACTION OF RACE BY SEX*************************


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19 RACE##SEX SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18



****INTERACTION BY RACE*************************


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(sample_final2): stcox c.EA4_01AD2WA_IGAP19##RACE RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18

****MEN******


mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_ADRD  [pweight = lwgtr], failure(ADRD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008



**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(male): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18



***WOMEN*****


mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_ADRD  [pweight = lwgtr], failure(ADRD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(female): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****WHITES****

mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_ADRD  [pweight = lwgtr], failure(ADRD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008

**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(White): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18


****AFRICAN AMERICANS***

mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_ADRD  [pweight = lwgtr], failure(ADRD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)


**MODEL 1: RACE, SEX AND AGE ONLY**

mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008


**MODEL 2: RACE, AGE, SEX AND OTHER SOCIO-DEMOGRAPHICS****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008


**MODEL 3: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION AND INCOME****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008


**MODEL 4: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME AND OTHER SES FACTORS****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008


**MODEL 5: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS, AND LIFESTYLE FACTORS****
mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 


**MODEL 6: RACE, AGE, SEX, OTHER SOCIO-DEMOGRAPHICS, EDUCATION, INCOME, OTHER SES FACTORS,  LIFESTYLE AND HEALTH-RELATED FACTORS****

mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 i.birth_cohort i.marital_2008 i.housmemnum_br_2008 i.education i.totwealth_2008 i.work_st_2008 i.fhi_2008  i.smoking_2008 i.alcohol_2008 i.physic_act_2008 bmi_2008  cardiometcond_2008 srh_2008


**MODEL 7: Model 1 AND ALL OTHER PGRS****

mi estimate: svy, subpop(AA): stcox EA4_01AD2WA_IGAP19 RACE SEX AGE2008 EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18



capture log close

log using "D:\HRS_PROJ\OUTPUT_FINAL\TABLES3.smcl",replace

use finaldata_imputed_FINAL,clear


mi svyset secu [pweight=lwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset AGE_EXIT_ADRD  [pweight = lwgtr], failure(ADRD_INC_CUM==1) enter(AGE_BASELINE2008) id(HHIDPN) scale(1)

**TABLE S3**

capture drop marital_2008g* educationg* work_st_2008g* fhi_2008g*  housmemnum_br_2008g* totwealth_2008g* smoking_2008g* alcohol_2008g* physic_act_2008g* srh_2008g*

tab marital_2008,generate(marital_2008g)

tab education, generate(educationg)

tab work_st_2008, generate(work_st_2008g)

tab fhi_2008, generate(fhi_2008g)

tab housmemnum_br_2008, generate(housmemnum_br_2008g)

tab totwealth_2008,generate(totwealth_2008g)

tab smoking_2008, generate(smoking_2008g)

tab alcohol_2008,generate(alcohol_2008g)

tab physic_act_2008,generate(physic_act_2008g)

tab srh_2008,generate(srh_2008g)

save, replace

/////////////////REDUCED MODEL//////////////////////////


foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA  if sample_final2==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}



foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA  if male==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}




foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA  if female==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}


foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA if White==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}


foreach m of varlist EA4_BMI2_GIANT18 EA4_WHR_GIANT15 EA4_HEIGHT2_GIANT18 EA4_EVRSMK_TAG10 EA4_CANNABIS_ICC18 EA4_NEUROT_SSGAC16 EA4_WELLB_SSGAC16 EA4_BIP_PGC11 EA4_CD_CARDIOGRAM11 EA4_CORT_CORNET14 EA4_T2D_DIAGRAM12 EA4_ADHD_PGC17 EA4_MDD2_PGC18 EA4_EXTRAVER_GPC16 EA4_AUTISM_PGC17 EA4_LONG_CHARGE15 EA4_AB_BROAD17 EA4_EDU3_SSGAC18 EA4_OCD_IOCDF17 EA4_NEBC_SOCGEN16 EA4_PTSDC_PGC18 EA4_HDL_GLGC13 EA4_LDL_GLGC13 EA4_ANXCC_ANGST16 EA4_CKDTE_CKDGEN19 EA4_HTN_COGENT17 EA4_ALC_PGC18 EA4_PP_COGENT17 EA4_HBA1CEA_MAGIC17 EA4_GCOG2_CHARGE18 {
mi estimate, cmdok: med4way EA4_01AD2WA_IGAP19 `m' SEX AGE2008  AA if AA==1, a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
	
}


capture log close


log using "D:\HRS_PROJ\OUTPUT_FINAL\FIGURES3_SUPPFIG2.smcl",replace


***FIGURE 3: FULL MODEL WITH ALL PGS RESULTS, AD: OVERALL, BY SEX AND BY RACE*************************\

use FIGURES3_SUPPFIG2 ,clear

capture drop UCL
gen UCL=BETA+1.96*SE

capture drop LCL
gen LCL=BETA-1.96*SE

save, replace

capture label drop PGSlab
label define PGSlab 1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18"



**AD, OVERALL**

twoway rcap UCL LCL ID if OUTCOME==1 & RACE==0 & SEX==0, yline(0) title("AD, overall") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==1 & RACE==0 & SEX==0

graph save FIGURE3A.gph,replace

**AD, Men**

twoway rcap UCL LCL ID if OUTCOME==1 & RACE==0 & SEX==1, yline(0) title("AD, Men") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==1 & RACE==0 & SEX==1

graph save FIGURE3B.gph,replace

**AD, women**


twoway rcap UCL LCL ID if OUTCOME==1 & RACE==0 & SEX==2, yline(0) title("AD, Women") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==1 & RACE==0 & SEX==2

graph save FIGURE3C.gph,replace


**AD, Whites**

twoway rcap UCL LCL ID if OUTCOME==1 & RACE==1 & SEX==0, yline(0) title("AD, White adults") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==1 & RACE==1 & SEX==0

graph save FIGURE3D.gph,replace

**AD, African American**

twoway rcap UCL LCL ID if OUTCOME==1 & RACE==2 & SEX==0, yline(0) title("AD, African American adults") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==1 & RACE==2 & SEX==0

graph save FIGURE3E.gph,replace



***FIGURE S2: FULL MODEL WITH ALL PGS RESULTS, ADRD: OVERALL, BY SEX AND BY RACE*************************\

use FIGURES3_SUPPFIG2,clear

capture drop UCL
gen UCL=BETA+1.96*SE

capture drop LCL
gen LCL=BETA-1.96*SE

save, replace

capture label drop PGSlab
label define PGSlab 1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18"

label val ID PGSlab


**DEMENTIA, OVERALL**

twoway rcap UCL LCL ID if OUTCOME==2 & RACE==0 & SEX==0, yline(0) title("ADRD, overall") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==2 & RACE==0 & SEX==0

graph save FIGURES2A.gph,replace

**DEMENTIA, Men**

twoway rcap UCL LCL ID if OUTCOME==2 & RACE==0 & SEX==1, yline(0) title("ADRD, Men") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==2 & RACE==0 & SEX==1

graph save FIGURES2B.gph,replace

**DEMENTIA, women**


twoway rcap UCL LCL ID if OUTCOME==2 & RACE==0 & SEX==2, yline(0) title("ADRD, Women") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==2 & RACE==0 & SEX==2

graph save FIGURES2C.gph,replace


**DEMENTIA, Whites**

twoway rcap UCL LCL ID if OUTCOME==2 & RACE==1 & SEX==0, yline(0) title("ADRD, White adults") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==2 & RACE==1 & SEX==0

graph save FIGURES2D.gph,replace

**DEMENTIA, African American**

twoway rcap UCL LCL ID if OUTCOME==2 & RACE==2 & SEX==0, yline(0) title("ADRD, African American adults") ytitle(LnHR) xtitle("PGS") xlab(1 "EA4_01AD2WA_IGAP19" 2 "EA4_BMI2_GIANT18" 3 "EA4_WHR_GIANT15" 4 "EA4_HEIGHT2_GIANT18" 5 "EA4_EVRSMK_TAG10" 6 "EA4_CANNABIS_ICC18" 7 "EA4_NEUROT_SSGAC16" 8 "EA4_WELLB_SSGAC16" 9 "EA4_BIP_PGC11" 10 "EA4_CD_CARDIOGRAM11" 11 "EA4_CORT_CORNET14" 12 "EA4_T2D_DIAGRAM12" 13 "EA4_ADHD_PGC17" 14 "EA4_MDD2_PGC18" 15 "EA4_EXTRAVER_GPC16" 16 "EA4_AUTISM_PGC17" 17 "EA4_LONG_CHARGE15" 18 "EA4_AB_BROAD17" 19 "EA4_EDU3_SSGAC18" 20 "EA4_OCD_IOCDF17" 21 "EA4_NEBC_SOCGEN16" 22 "EA4_PTSDC_PGC18" 23 "EA4_HDL_GLGC13" 24 "EA4_LDL_GLGC13" 25 "EA4_ANXCC_ANGST16" 26 "EA4_CKDTE_CKDGEN19" 27 "EA4_HTN_COGENT17" 28 "EA4_ALC_PGC18" 29 "EA4_PP_COGENT17" 30 "EA4_HBA1CEA_MAGIC17" 31 "EA4_GCOG2_CHARGE18", angle(90))  || scatter BETA ID if OUTCOME==2 & RACE==2 & SEX==0

graph save FIGURES2E.gph,replace



