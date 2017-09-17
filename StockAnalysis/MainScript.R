source("Helper.R")
SetupEnvironment(requiredPackages = c("caret", "reshape", "data.table"))

# read single file

data <- read.csv("../../../Downloads/mstcgl/MBANK.mst", header = TRUE)

# get data bulk
# http://stackoverflow.com/a/11433532/3922292
# temp = list.files(path = "../../../Downloads/test", pattern="*.mst", full.names	= TRUE)

# rename column names
names(data) <- gsub("X.", "", names(data))
names(data) <- gsub("\\.", "", names(data))
names(data) <- sapply(names(data), ToCamelCase)
# add columns

data = as.data.table(data)

data[, OpenChange := Open / shift(Open, 1L, type = "lag")]
data[, HighChange := High / shift(High, 1L, type = "lag")]
data[, LowChange := Low / shift(Low, 1L, type = "lag")]
data[, CloseChange := Close / shift(Close, 1L, type = "lag")]
data[, VolChange := Vol / shift(Vol, 1L, type = "lag")]


# add predicted value

data[, Predicted := Close < shift(Open, 1L, type = "lead")]

#rm(list = ls())

# Split into training and validation

validation_index <- createDataPartition(data$Ticker, p = 0.80, list = FALSE)

validation <- data[-validation_index,]

data <- data[validation_index,]

# make predictions
