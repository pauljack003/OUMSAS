# Assignment 5A: Scientific Report Project

# Table of Contents
- [Introduction](#Introduction)
- [Background](#Background)
- [Research Question/Hypothesis](#Research-QuestionHypothesis)
- [Methodology](#Methodology)
- [Results](#Results)
- [Discussion](#Discussion)
- [Conclusion](#Conclusion)

## Introduction

I'm not really sure what to write about, since the instructions aren't specific: so I'll write a mostly tongue-in-cheek _somewhat scientific report_ about the effects of the listening to [Pearl Jam](https://pearljam.com/), an American rock band that gained massive popularity in the 1990s. 

I'll generate a randomized dataset as if subjects were asked to rate their happiness before and after listening to a Pearl Jam album, and then analyze that (fake) dataset as if the experiment had actually taken place. For this analysis, I'll use R.

I'm also going to ensure I meet the following requirements as laid out in the Assignment, shown below:

![requirements](https://raw.githubusercontent.com/pauljack003/OUMSAS/cdaaab6083b3c007a827e47ead41f45730f89b01/DSP5673/images/Requirements.png)

---

## Background

### General background

Via [Wikipedia](https://en.wikipedia.org/wiki/Pearl_Jam):

>Formed after the demise of ... Green River and Mother Love Bone, Pearl Jam broke into the mainstream with their debut album, Ten, in 1991. Ten stayed on the Billboard 200 chart for nearly five years, and has gone on to become one of the highest-selling rock records ever, going 13× Platinum in the United States. Released in 1993, Pearl Jam's second album, Vs., sold over 950,000 copies in its first week of release, setting the record for most copies of an album sold in its first week of release at the time. Their third album, Vitalogy (1994), became the second-fastest-selling CD in history at the time, with more than 877,000 units sold in its first week.

### Most well known songs

The band is known for its extensive catalogue, but its best songs as measured by charting position are:

1. Last Kiss, No Boundaries, 05/1999
2. Given to Fly, Yield, 01/1998
3. I Got ID, Merkin Ball EP, 12/1994
4. Better Man, Vitalogy, 12/1994
5. Who You Are, No Code, 08/1996
6. Daughter, Vs., 10/1993
7. Jeremy, Ten, 08/1992
8. Spin the Black Circle, Vitalogy, 11/1994
9. Nothing As It Seems, Binaural, 04/2000
10. Dissident, Vs., 03/1994

### Band lineup

Current lineup: 
* **Eddie Vedder**
* **Jeff Ament**
* **Stone Gossard**
* **Mike McCready**
* **Matt Cameron**

Past members include:	
* Dave Krusen
* Matt Chamberlain
* Dave Abbruzzese
* Jack Irons

----

## Research Question/Hypothesis

Given the band's longevity, it's reasonable to assume that people enjoy listening to Pearl Jam's music. But does this enjoyment translate to actual improvement in happiness? If so, this would suggest that listening to Pearl Jam, for fans of the band, is a way to improve their overall sentiment -- a finding that would carry significant implications for other forms of music, not to mention having broader impact on society (ie, happier people in general are better for society than less happy people).

----

## Methodology

Obviously, this isn't a real study. But I am pretending that we conducted a study whereby 5,000 partipants were asked to rate their happiness on a 10 point scale (10 being happiest) both before and immediately after listening to a Pearl Jam album. I went ahead and used R to generate a fake dataset as if a study had actually been conducted. The code used to generate this example dataset in R is provided below:

```r
# Load necessary libraries
library(dplyr)
library(ggplot2)

# Create a sample dataset with random data
set.seed(123)
PearlJam_happiness <- data.frame(
  ID = 1:5000,
  Album = sample(c("Ten", "Vs", "Vitalogy", "Binaural", "Yield"), 5000, replace = TRUE),
  PriorHappiness = sample(1:10, 5000, replace = TRUE)
)

# Ensure AfterHappiness is generally higher than PriorHappiness
PearlJam_happiness <- PearlJam_happiness %>%
  mutate(AfterHappiness = pmin(10, PriorHappiness + sample(0:3, 5000, replace = TRUE)))

# Summary statistics
summary(PearlJam_happiness)
```

----

## Results

The descriptive results seem to suggest a clear increase in affective happiness immediately after listening to a Pearl Jam album -- the effect appears to exist across all Pearl Jam albums tested in the fake dataset.

![Prior Happiness](https://raw.githubusercontent.com/pauljack003/OUMSAS/2cfd1ee0c9464a0bd142b57c2d73be83bed8a34b/DSP5673/images/Before.png)

![After Happiness](https://raw.githubusercontent.com/pauljack003/OUMSAS/2cfd1ee0c9464a0bd142b57c2d73be83bed8a34b/DSP5673/images/After.png)

A review of key summary statistics shows that mean happiness increased from 5.504 prior to listening to 6.751 after listening, as shown in the table below.

| Statistic      | ID              | Album             | PriorHappiness | AfterHappiness  |
|----------------|-----------------|-------------------|----------------|-----------------|
| Min.           | 1               | Length:5000       | 1.000          | 1.000           |
| 1st Qu.        | 1251            | Class:character   | 3.000          | 4.000           |
| Median         | 2500            | Mode:character    | 6.000          | 7.000           |
| Mean           | 2500            |                   | 5.504          | 6.751           |
| 3rd Qu.        | 3750            |                   | 8.000          | 10.000          |
| Max.           | 5000            |                   | 10.000         | 10.000          |

A more rigorous t-test of the results shows thet the increase in happiness for each album is, indeed, statistically significant.

| Album    | t_statistic | p_value      |
|----------|-------------|--------------|
| Binaural | -36.4       | 2.68e-185    |
| Ten      | -35.9       | 1.12e-182    |
| Vitalogy | -37.4       | 2.00e-191    |
| Vs       | -37.2       | 2.41e-193    |
| Yield    | -35.4       | 1.19e-176    |

---

## Discussion

The results here, fake though they may be, are a fun way to visualize and analyze data about music in a scientific report format. The data shows that listening to a Pearl Jam album increases the reported happiness of Pearl Jam fans.

There is ample research that shows increased happiness and associated satisfaction leads to increased productivity, better cooperation, higher levels of empathy, and more. This fake study shows that music may have a direct role to play in helping facilitate these positive societal outcomes.

There are of course limitations: first of all, we only measured reported happiness, so it's possible that actual happiness doesn't correlate with a person's reported happiness; likewise, it's possible this effect is only limited to Pearl Jam fans and fans of other bands, like for example Metallica, may be less happy after listening to that band's music. Further research could explore such effect and quantify them so we can better understand the role music plays in influencing the emotional well being of people in general.

----

## Conclusion

Overall, this analysis is completely fake but it's a fun exercise designed to meet the requirements of an assignment while also getting to practice Markdown and use some R coding skills. The data we generated here suggests what is likely an obvious outcome of listening to music that someone likes: that person is in a measurably better mood, with all sorts of associated outcomes that impact society.










