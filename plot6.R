if (!require(sqldf))
  install.packages("sqldf")
library(sqldf)

## Load Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract total PM2.5 for each year for Baltimore and LA from vehicle sources

emissionForLAandBL <-sqldf('select year, fips, sum(Emissions) as cumulativeEmission from NEI where type="ON-ROAD" and fips in ("24510", "06037") group by fips, year')

emissionForLAandBL<-transform(emissionForLAandBL,year=factor(year))

## Map County Name to fips and append to the data frame

fipsName <- data.frame(fips = c("24510", "06037"), name = c("Baltimore City, Maryland", "Los Angeles County, California")) 

emissionDataByfipsName <- data.frame(County = factor(emissionForLAandBL$fips, labels = fipsName$name))

emissionForLAandBL <- cbind(emissionForLAandBL, emissionDataByfipsName)

library(ggplot2)

## Plot data

png("plot6.png")

g <- ggplot(emissionForLAandBL, aes(x=year, y=cumulativeEmission, fill = County)) +
  geom_bar(stat = "identity") +
  facet_grid(County ~ ., scales="free") +
  labs(y = expression("Total PM"[2.5]*" emission from motor vehicle sources"), 
       x = "Year", 
       title = expression("Variation in motor vehicle emissions\nBaltimore City Vs Los Angeles County")) +
   theme(panel.background = element_rect(fill = 'beige', colour = 'red'))

print(g)

dev.off()
