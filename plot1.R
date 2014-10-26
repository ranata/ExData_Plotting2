if (!require(sqldf))
  install.packages("sqldf")
library(sqldf)

## Load Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract total PM2.5 for each year
emissionDataByYear <-sqldf('select year, sum(Emissions) as cumulativeEmission from NEI group by year')

## Convert cumulativePM2.5 to million and year as factors for the plot

emissionDataByYear$cumulativeEmission <- emissionDataByYear$cumulativeEmission/1000000

emissionDataByYear<-transform(emissionDataByYear,year=factor(year))

## Plot yearly cumulative emission data

png("plot1.png")

barplot(names.arg = emissionDataByYear$year, 
     height = emissionDataByYear$cumulativeEmission, col=c("orange"),
     width = 0.5, xlim = c(0, 4), 
     xlab="Year", ylab=expression('Total PM'[2.5]*' emission (in Million)'), 
     main=expression('Total PM'[2.5]*' emission by year'))

dev.off()
