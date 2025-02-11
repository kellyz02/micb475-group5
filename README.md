# MICB475-Group5-Agenda & Meeting Minutes
## 05/Feb/2025
_Meeting minutes: Jeyah_

### Discussion 

**Datasets/Topics of Interest** 
- Zoo captivity
  - Does a certain diet type exacerbate the impact of captivity on the animal’s microbiome?
    - The study seems to already cover this main question by investigating diet type/diet breadth on microbiome diversity.  
    - Could we instead specifically compare different animal species?
    - From the paper: future directions alluded to studying reduced fiber uptake in captive animals
  - Look into locations / climate?
  - Maturity of the animals?
  - Question for the TA: If we were to use this dataset, is it best to focus on specific species, rather than all the species sampled?
- Anemia / Infant (potentially combining the two)
  - How do the microbiomes of children who are stunted or wasted compare? 
    - Composition? Richness? Abundance? 
  - Could potentially look at stunting or wasting individually between the two datasets
  - Compare microbiomes from children stunting and wasting from two different locations 
  - Comparative analysis of the impact of anemia vs. infant feeding on stunting? 
  - How does stunting impact the microbiomes of children in general (treating the 2 datasets as 1 big one)?
- Potential datasets that didn’t make the cut: Gastric cancer, Alcohol, & MS

### Meeting Minutes

**Final choice: Zoo captivity dataset** 
- TWO MAIN IDEAS:
  - Comparing geographical locations
  - Comparing within family
- We will start off exploratory → hard to write a proposal
  - All orders separated by location?
  - Not everything is going to be significantly different
  - It would be cool if one is significant (even if insignificant factor, that finding is still a result)  → we do a functional analysis → tease out different metadata categories within that group
  - We’ll start with analyzing everything, then compare between families maybe?

**Next steps: Exploratory data analysis** 
- Create several different metadata files and phylo seq objects
- Have one filter per order
- For each order, explore different locations
- Do diversity metrics on them (IN R; Evelyn suggests not to do it in qiime as R is more flexible)
- Depending on what we find, choose which one(s) is/are significant 

**Things to keep in mind**
- Keep a copy of every file you generate. Qza and qzv
- ZOO DATASET IS BIG
  - It will probably take full days to denoise and demultiplex → detached screen
- Make decisions as a team (e.g., what rarefaction parameter?) → we can even ask bessie for her input

### Action Items
- Read through proposal documents on Canvas (everyone)
- Have an idea for proposal outline (everyone)



## 12/Feb/2025
_Meeting minutes: Emilie_
Preliminary agenda (written 11/2/2025): 
 -Quiime 2 data processing underway. Demux file has been created and there are ongoing disucssions being held about truncation length.  
 -Proposal planning underway with the following assingments: 
     Introduction and Background: Emilie (and Jeyah)
     Research Objective: Jeyah (and Emilie)
     Experimental Aims and rationale: Sherrill
     Approach + Overview chart: Kelly
     Dataset overview: Catherine	 
     Timeline (Gantt Chart): Jeyah
     Participation report: Everyone
-Phyloseq script will be created, and everyone will pick different metadata objects to explore further. Analysis and metrics will be run (by saturday) and results will be discussed on team meeting scheduled next tuesday. 


## 19/Feb/2025 (note: meeting by request)
_Meeting minutes: Sherrill_

## 26/Feb/2025
_Meeting minutes: Cat_

## 05/Mar/2025
_Meeting minutes: Kelly_

## 12/Mar/2025
_Meeting minutes: Jeyah_

## 19/Mar/2025
_Meeting minutes: Emilie_

## 26/Mar/2025
_Meeting minutes: Sherrill_

## 02/Apr/2025
_Meeting minutes: Cat_

## 09/Apr/2025 (note: meeting by request)
_Meeting minutes: Kelly_

## 16/Apr/2025 (note: meeting by request)
_Meeting minutes: Jeyah_
