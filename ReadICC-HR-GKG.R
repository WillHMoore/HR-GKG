# 19 Jan 2015
# C Fariss & WH Moore
# Reading and Reshaping the GDELT HR-GKG Data
#############################################


# Each Record (case, or row in the data matrix) contains multiple events of interest: 
# the Record is a Document (assigned a unique "GKGRecordID" value), each of which contains lots of HR events.
# As such, we need to reshape the data, creating a case for each event of interest, in this case the "COUNTS",
# which is described in Ver 2 of the GKG User Guide this way:
# "V1COUNTS (semi-colon delimited blocks, with pund symbol ("#") delimited fields)."
# We need to get R to create a new case for each block of vars (delimited by semi-colons in the "COUNTS" var),
# assigning the "GKGRecordID" value to that new case.  
# For this exercise (and to simplify) we drop all of the other variables coded with that "GKGRecordID"

# function define
foo <- function(X, SPLIT){
    return(unlist(strsplit(as.character(X), split=as.character(SPLIT))))
}


# Read the CSV file 
setwd("/home/will/Documents/Data/GDELT/HR-GKG/") 
ICCdata <- read.csv("HR-GKG.ICC.gkgv2.csv", sep="\t")

# make list object of the Counts field
dat <- as.list(ICCdata$Counts)

# apply function to list object (Counts field)
dat2 <- lapply(dat, foo, ";")

# make recordID vector for data.frame
recordID <- rep(1:nrow(ICCdata), unlist(lapply(dat2, length)))

# The next step creates the 10 distinct variables from the single block: splitting the info delimited by the "#"

# unlist for next pass through the lapply() function
dat2 <- as.list(unlist(dat2))

# apply function on list object
dat3 <- lapply(dat2, foo, "#")

# make data.frame and transpose it and then combine it with the recordID vector
dat4 <- data.frame(recordID, t(as.data.frame(dat3)))

# change row names of the data.frame
row.names(dat4) <- 1:nrow(dat4)

# change the column names of the data.frame into these variables:
#  1. recordID
#  2. CountType
#  3. Count
#  4. ObjectType
#  5. LocType
#  6. Location
#  7. LocCCode 
#  8. LocCntryAdmin 
#  9. Latitude 
# 10. Longitude 
# 11. Unknown
# 12. FeatureID  

names(dat4) <- c("recordID", "CountType", "Count", "ObjectType", "LocType", "Location", "LocCCode", "LocCntryAdmin", "Latitude", "Longitude", "Unknown", "FeatureID")

# We now have a matrix of Event Counts from the HR-GKG.  This file can be adopted for reading and reshaping other 
# variables of interest, such as the information contained in the Themes, Persons, etc. Fields in the HR-GKG files.

# examine new data.frame
head(dat4)


# save data.frame as csv file
write.csv(dat4, "ICC-EventsData.csv", row.names=F)

