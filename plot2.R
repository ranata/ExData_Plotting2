if (!require(sqldf))
  install.packages("sqldf")
library(sqldf)

## Load Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract total PM2.5 for each year for Baltimore

BaltimorePM2.5DataByYear <-sqldf('select year, sum(Emissions) as cumulativeEmission from NEI where fips ="24510" group by year')


BaltimorePM2.5DataByYear<-transform(BaltimorePM2.5DataByYear,year=factor(year))

## Plot yearly cumulative emission data

png("plot2.png")

barplot(names.arg = BaltimorePM2.5DataByYear$year,
        height = BaltimorePM2.5DataByYear$cumulativeEmission, col=c("Blue"),
        width = 0.5, xlim = c(0, 4), 
        xlab="Year", ylab=expression('Total PM'[2.5]*' emission'), 
        main=expression('Total PM'[2.5]*' emission in Baltimore City by year'))

dev.off()
