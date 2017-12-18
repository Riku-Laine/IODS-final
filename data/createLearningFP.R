# Author: Riku Laine
# Email: riku.laine@helsinki.fi
# Date: Mon Dec 11 13:43:43 2017
# Project name: IODS final project - Data wrangling
# Description

# This script is for creating the "learning2014" data set for Helsinki
# University's Introduction to Open data Science course. The data is acquired
# from http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt. Google's
# R Style Guide was tried to be followed in the making of this script.

# --------------
# Author:
# Date:
# Modification:
# --------------
# Preparations (source() and library())

# Importing libraries
library(MASS)
library(dplyr)

# Reading in the data
url <- "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"

learning2014 <- read.table(file = url, sep = '\t', header = T)

# Let's select the base variables gender, Age, Attitude and Points from
# the data frame learning2014 to create an.data.

an.data <- dplyr::select(learning2014, gender, Age, Attitude, Points)

# Constructing the variables as was instructed in the meta page
# here: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt.
# I decided to construct the partial variables to get more variables.

# Vectorize the original data set to simplify the following calls.
attach(learning2014)

an.data <- mutate(an.data, SeekingMeaning      =  (D03+D11+D19+D27)/4)
an.data <- mutate(an.data, RelatingIdeas       =  (D07+D14+D22+D30)/4)
an.data <- mutate(an.data, UseOfEvidence       =  (D06+D15+D23+D31)/4)
an.data <- mutate(an.data, LackOfPurpose       =  (SU02+SU10+SU18+SU26)/4)
an.data <- mutate(an.data, UnrelatedMemorising =  (SU05+SU13+SU21+SU29)/4)
an.data <- mutate(an.data, SyllabusBoundness   =  (SU08+SU16+SU24+SU32)/4)
an.data <- mutate(an.data, OrganizedStudying   =  (ST01+ST09+ST17+ST25)/4)
an.data <- mutate(an.data, TimeManagement      =  (ST04+ST12+ST20+ST28)/4)

# Remove the above created vectors.
detach(learning2014)

# Omit observations which had zero points from the final exam.
an.data <- an.data[an.data$Points!=0,]

# Create binarized variable for logistic regression
an.data$HighPoints <- an.data$Points > median(an.data$Points)

# Fix the first column name to be upper case as the others.
colnames(an.data)[1] <- "Gender"

# Set working directory and write the an.data data frame there excluding row names.
setwd(dir = "~/GitHub/IODS-final/data/")
write.csv(an.data, file = "learning2014.csv", row.names = F)
