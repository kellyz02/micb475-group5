# MICB475-Group5-Agenda & Meeting Minutes
### [To-Do & Timeline Google Doc](https://docs.google.com/document/d/1c9SF45MHagotgmzhL_JCIoF1-3Ngr-G65ER-98RIpRM/edit?usp=sharing)
### [Meeting Minutes Google Doc](https://docs.google.com/document/d/1gqU68g0OVO--qMp_WRkoWx3UNo-8WKKD1EjoDAbvpfA/edit?usp=sharing) 

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
**Preliminary agenda + Meeting notes (written 11/2/2025):** 
 - Quiime 2 data processing underway. Demux file has been created and there are ongoing disucssions being held about truncation length.
        - having issues with the truncation length- changed to 235 because a lot of samples were lost at 173. Number of samples is 91 which isn't a lot
        - looks like a lot of samples have reads that aren't good
        - most primates got filtered out
        - Lots of samples have significantly longer reads with drop in quality at the end
        - could still work, less accurate but if we need to choose between samples vs quality, should keep as many samples as possible
        - try no truncation to ensure that all samples are retained
        - Previous groups truncated at 150 and they retained 98%?
 - Proposal planning underway with the following assingments: 
      - Introduction and Background: Emilie (and Jeyah) 
      - Research Objective: Jeyah (and Emilie) 
      - Experimental Aims and rationale: Sherrill 
      - Approach + Overview chart: Kelly 
      - Dataset overview: Catherine  
      - Timeline (Gantt Chart): Jeyah
      - Participation report: Everyone 
- Phyloseq script will be created, and everyone will pick different metadata objects to explore further. Analysis and metrics will be run (by saturday) and results will be discussed on team meeting scheduled next tuesday.
      - can always merge figures for final manuscript 
- withing the same order, some captive and some wild- at different zoos and different santuaries. Do we still want to compare within zoos- otherwise we need to control for other features
- previous paper looked at geography and diet --> confirm that climate is different enough from geography
      - our results could also be different then the previous paper since they truncated and lost many samples
- use the Koppen Climate Classification which we will assign based on metadata temperature and precipitation columns
       - A: Tropical climates, where all months have average temperatures above 18°C
       - B: Dry climates, where there is deficient precipitation for most of the year
       - C: Temperate climates with mild winters
       - D: Continental climates with cold winters
       - E: Polar climates, found in the Arctic and Antarctic
  - we can also take into consideration the city and location of zoo and use that in our classification
       - we can subset our data based on the climate catagory
- Are we still looking at captivity?
       - is wild vs captive independent from climate status? If combined- number of sampels will drop
       - if not significantly different then we will group them together
- Consider that other papers have truncated significantly and thus lost a lot of samples. Since we have decided to not truncate, we could reproduce their code and get different results

Research Question: Does climate influence microbiome of different classes of annimals? Does this differ between wild and captive animals (i.e. is it captivity specific)? 
       - if we find a significant different in types of bacteria in certain climate- we could do a functional analysis- does the bacteria order/class affect the micrbiota in a climate repsonse 
- We will need to do metadata wrangling:
      - add climate status column, have 5 catagories (removing all that columns that we don't need- can even remoce temperature and precipitation once climate classification is added)
      -  Might be easier to change metadata and add climate, get rid of everything else that we don’t need, then go and generate table .qza and .qzv → denoising step outputs the table so need to repeat the denoising step
      - Will we do the indicator test (only does pairwise comparison)
Workflow: 
 - Classify each based on climate 
 - Within a climate, look at the microbiomes
 - Compare microbiomes of same class between climates 
 - Within a climate, look at different

Action:
- jeyah (and kelly) will do the metadata. Phyloseq is pushed back as it is not needed for proposal
- meeting on tuesday 8am (attended by Bessie) to discuss qiime results and proposal items
- Bessie will contact evelyn about truncation lengths
- Jeyah and catherine will switch proposal sections

Rubric tips
- title shouldn't be broad or too conclusive
- be specific about climate status
- background and intro: define all key terms, research needs to be cited but don't force a knowledge gap
- hyptoehsis: provide a prediction- what do we think will happen, find previous literature (ie wetter climate = increased diversity)
- experimental aims:e very specific, talk about what we are doing and WHY and how it relates to the question 
- Don’t forget to reference qiime and package
- Don't want us to repeat steps: When describing diversity analysis we don’t need to say we did qiime if we said alread
- Mention what files we are using 
- Keep the read length, depth, sample size, justify truncation, primers, rareifaction
Confirm which style works (ASM) 


---
## 18/Feb/2025 (note: meeting by request)
_Meeting minutes: Sherrill_

**Agenda (written Feb 17):**
- Informal meeting to get our bearings!
  - Updated qiime results?
  - Update on truncation lengths from Evelyn?
  - Any further clarifications and planning on proposal ***(due Sun, Feb 23)***

**Minutes**
- **One of the servers doesn’t grant permissions to upload?
  - tmp → temporary files, might be something wrong with this folder that is not producing intermediate files
  - Be sure to remove chloroplast + mitochondrial sequences → might help
- Truncation length: a lot of samples aren’t too good in this metadata
  - Relatively long truncation length (~200) still has bad quality → still filtered
  - 150 should be fine for our purposes to keep as many decent samples as we can, though it’s not ideal
    - ***we will also truncate at 150***
- Koppen classification can have subcategories, smaller letters (e.g., certain amount of precipitation) → can maybe stratify just in case, but we might not have enough data for significant enough comparisons between more niche subcategories
  - If we need to do research to define the main 5 categories, then we can do research if we need to further define subcategories
  - If there is enough info in metadata for main 5, then just stick to main 5
- ***Temperature issue***: temperatures are in the 100s (˚C)
  - France in particular gets very low (~4.8) or very high (~200+)
  - Can try to search for mean temperatures for each place of that year, and use that information instead

Proposal:
- Introduction: no set number of sources, just as long as things are sufficiently clear/defined

*To-Do*:
- Trying rarefaction again
- Bessie will check on the temperature issue (asking authors directly not ideal)
  - If we can’t find info… we can do our own research on temperature



## 26/Feb/2025
_Meeting minutes: Cat_

**Agenda/Minutes:**
- Bessie updates
  - Proposal graded by Hans, not Bessie
  - Agreed to use map to assign climate categories

- Proposal & project
  - Do alpha and beta diversity analyses directly in R so that we can do stats right away
  - DESeq2 (tells us sig ASVs) is not necessary since we are mainly looking at the effect of climate change → not necessary to do
      - Bessie can write us a script to automate
  - 4 x 6 DESeq analyses = 9ish/person
  - Total 6 animal orders, 4 (out of 5 total) climate categories
  - Can only look at climate differences if captivity status for an order is not significant
  - Make a discussion after aim 1 before moving on to aim 2, to frame what we will be doing in the next steps

- Go over weekly to-do list (make more detailed)
  - See MICB 475: Meeting Minutes Schedule, Timeline, To do
  - Split up 6 orders between ourselves - 1 person writes alpha div code, 1 person writes beta diversity code
  - Next week, split up Aim 2 based on our findings

- Peer-feedback survey?
  - Very informal, just to make sure everyone contributes to writing and analysis

- Lab notebook format (Github)
  - Store everything in Github (all files, incl. Intermediate files & script)
  - To upload bash code - text file with commands


## 05/Mar/2025
_Meeting minutes: Kelly_

#### **Part 1: Proposal Revision**
___Reflections + Feedback:___
- Adjusting + refining our aims to be more specific (i.e. breaking them down?)
- Adjusting our approach to be more specific, and get rid of Aim 1 differential + functional analysis
- Ensure consistency between all the sections to avoid reader confusion
- **General Notes:**
    - We should list out every single possible scenario because it is an exploratory analysis, make it more clear that it is exploratory. 
    - General Confusions: 
        - how we’re classifying climate
        - what exact analysis we’re doing
            - there’s a million comparison groups, so we should refine what analysis we want to prioritize 
- **Introduction Notes:**
    - Need more traditional elements
    - Refine research question 
    - Not enough information about WHY we want to study this context (effect of climate status on gut microbiome), why is it important to study gut microbiome in general about these animals (i.e. instead of their immune cell composition) 
        - Can we modify their microbiome? 
        - Can we prevent disease in their microbiome? 
    - Effect of climate on the gut microbiome:
        - What are the known mechanisms that climate can impact the gut microbiome (independent/dependent on diet) (although probably will end up talking about diet, because climate is highly intertwined as it impacts the availability of food) 
            - research gap: because the relationship between climate and the gut microbiome is understudied, we suspect that the relationship between gut microbiome and diet means that there will be an effect by climate too. 
    - Don’t mention the hypothesis in the introduction 
    - *Potential motivating question we want to make sure we address: If diet was the main contributor here, why did we decide to use climate? Because for wild animals it’s hard to determine their diet composition, so we want to use climate as an indicator.*
    - General order/flow of intro: 
        - gut microbiome impact on animals 
            - 1 major factor of gut microbiome is diet
        - BUT diet not always known, especially in wild, so climate could act as a good indicator (proxy)
            - **make sure to spend several sentences on this: climate acting as a predictor of diet (connect the gap between climate → diet → gut microbiome)**
            - give examples of how it does: e.g. rain may cause prey to be less present, are hunting behaviours different based on climate, how is vegetation impacted by climate? 
            - *make sure to really address the question of why we’re doing climate instead of diet, refrain from strengthening diet too much *
        - BUT there is a research gap: the relationship between climate + gut microbiome is understudied so we want to investigate this. 
        - Tying it into captivity: There is a difference in diet between wild and captivity, so it is a variable that we want to make sure we explore the impact of this too 
        - In this project, we aim to use this data to answer these following questions…  
    - Referencing UJEMI papers: a lot of them were irrelevant to our research question, were only similar because of the dataset → is it okay if we just use the most relevant one, and not bring up the others? 
        - If they compared wild vs. captivity status, it could be useful to still reference 
    - We could either keep the dataset introduction in the intro or we could move it to dataset overview 
- **Experimental Aims:**
    - Currently we have 2 aims, but let’s separate them into more aims 
    - Aim 1: For each order of animal,  Compare alpha + beta diversity between the 4 different climate statuses across the 6 different animal orders (box plot) 
    - Move climate status to beginning step: 
    - **Aim 1:** For each order of animal, compare alpha and beta diversity across the 4 different climate statuses, and compare taxa barplots for each climate in order 
        - easier to explain that there is no difference between the climate status groups because of the wild + captivity status, so better to do climate first and then do wild + captivity status 
        - **alpha diversity**: e.g. boxplots for each order, where climate A, B, C, D are grouped, and use wilcox test (OR if its just 2 climates represented, then you’ll have to adjust the test to whatever is more than pairwise categorical)
        - **beta diversity**: PCoA plot + PERMANOVA 
        - because of shannon + faith PD look at different metrics -> significantly different in phylogenetic but not shannon, then they must have similar evenness but the species are phylogenetical distant from each other  
        - **taxa barplot**: even if alpha diversity may not be different, do we see a different representation of taxa (especially because the animals are similar to each other) -> across climate in each order 
            * preview to our indicator taxa + core microbiome analysis in Aim 2! 
    - **Aim 2**: Because (likely) that climate didn’t have an impact on diversity, then we want to see the impact of wild + captivity between the climate statuses using alpha and beta diversity boxplots, indicator taxa analysis, and core microbiome analysis 
        - **boxplot**: 2 boxplots for captive and wild, for each climate status in one plot. (e.g. 8 boxplots (if all the climate statuses are represented across each order))
        - within group + across group comparison: do 2-WAY ANOVA. 
        - if they different within one climate status, that means captivity has an effect here 
        - *is the effect of captivity is bigger wild (compared to captive animals) animals -> compare wild animals ACROSS all the climate statuses, compare captive animals ACROSS all climate statuses*
        - ***we need to make sure we have wild and captive status animals for each climate IN EACH ORDER.  → and if we don’t have that then, we throw away that climate group, for that order.***
        - **not necessary to do taxa barplot, will do indicator taxxa + core microbiome**
    - **Possible scenario 1:**
        - For each order of animal, we have 5 different climate statuses (and compare diversity between climates)
            - say we don’t see a significant difference
        - However, once we divide by captivity + wild, and say we do see a significant difference, then captivity + wild is a main indicator here. 
    - **Aim 3: Core Micorbiome + Indicator Taxa + DIFFERENTIAL  analysis for ANY SIGNIFICANT GROUPS**
    - **AIM 4: FUNCTIONAL ANALYSIS**

*Fixes:*
- **Action Item:** Make a table, how many animals in this order and climate, how many are wild and captive so we know which groups will need to be eliminated from our analysis 
    - order on x axis
    - climate on y axis 
- Add tool citations (Kelly)
- Remove differential expression + functional analysis from Aim 1 approach (Kelly)


#### **Part 2: Analyzing Alpha + Beta Analysis**

**Interpreting our results:**
- Shannon Diversity, significant results: captivity has an impact, regardless of climate status 
    - Primates
- Faith's PD, significant results: captivity has an impact, regardless of climate status
    - Tubulidentata
    - Pilosa
- wild animals from different climates clustered with each other → is there perhaps a similarity between these climates? 
- If animals have a similar gut microbiome in both captivity and wild, then that means that living in climate X means that it ensures that ideal diets are fulfilled, regardless of captivity status. 

## TO-DO LIST FOR NEXT WEEK:
- **Get draft changes to Bessie by Saturday NIGHT, so she has Sunday to look for it:**
  - Introduction edits: Emilie + Jeyah
  - Hypothesis + Question (if needed?): Cat
  - Aim edits: Sherill + Kelly
  - Approach edits: Kelly 
  - Citation edits: Kelly
  - GANTT chart edits: Jeyah
- Change the alpha diversity script + generate alpha diversity plots for Aim 1: Kelly (by next meeting)
- Create taxa barplot script - Jeyah (by next meeting)
- Create table of groups - Cat (by next meeting)

## 12/Mar/2025
_Meeting minutes: Jeyah_

### Discussion 

**Alpha Diversity Plots** 
- Look through the new plots Kelly generated as a team!

**Taxa Bar Plots** 
- Look through the taxa bar plot Jeyah generated
- Used phylum as the taxonomic rank but can discuss potentially using something else

**Next Steps** 
- Aim 2
  - Alpha and beta diversity + statistical analysis focusing on captivity
- Aim 3
  - Perform taxonomic analysis on significant groups from Aim 1 and 2

-> Think it might be a good idea to work on aims 2 and 3 this week?
- Aim 4
  - Perform functional analysis on significant groups


## 19/Mar/2025
_Meeting minutes: Emilie_
**Agenda** 
 - Update on the Taxa bar blot (i.e. colour separation)- questions for Bessie
 - Discussion on aim 1: look at the graphs produced by Jeyah and Kelly
     - Jaccard
     - Unifrac
     - Weighted Unifrac
     - PCOA
         - Were dot overlays fixed?
 - Discussion of aim 2: Kelly’s alpha diversity analysis 
     - Permanova analysis 
     - Permanova summarization table from Cat
 - Discussion of aim 3: Emilie Has many questions on CM and IT
     - Core microbiome 
     - Indicator Taxa 
     - DEseq 


## 26/Mar/2025
_Meeting minutes: Sherrill_

**Agenda (written Mar 25):**
- PERMANOVA issue resolved!
- Clarification on animal/bacterial order:
  - Results and plots are looking at bacterial taxa (not looking at taxonomic relationships between the animal orders)
- Aim 3 analyses (core microbiome, indicator species, DESeq)
  - Note: unrarefied phyloseq seems to be okay for all three analyses
  - (examples from Module 16 used the unrarefied mpt_final instead of the rarefied mpt_rare object)
- Presentation discussion: how would we like to proceed and structure it?
  - Slides due _**Mar 30**_
  - We present Team 6's slides on _**Apr 3**_

## 02/Apr/2025
_Meeting minutes: Cat_

## 09/Apr/2025 (note: meeting by request)
_Meeting minutes: Kelly_

## 16/Apr/2025 (note: meeting by request)
_Meeting minutes: Jeyah_
