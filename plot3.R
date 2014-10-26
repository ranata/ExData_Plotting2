if (!require(sqldf))
  install.packages("sqldf")
library(sqldf)

## Load Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract total PM2.5 for each year for Baltimore for each source

EmissionDataByYearAndType <-sqldf('select year, type, sum(Emissions) as cumulativeEmission from NEI where fips ="24510" group by type, year')


EmissionDataByYearAndType<-transform(EmissionDataByYearAndType,year=factor(year))

library(ggplot2)

## Plot data

png("plot3.png", height=480, width=720)

g <- ggplot(EmissionDataByYearAndType, aes(year, cumulativeEmission, fill = type))

g <- g + geom_bar(stat = "identity") + 
  facet_grid(. ~ type, scales = "free") +
  labs(title = expression("Total Baltimore PM"[2.5]*" emission by source"), 
       x = "Year", 
       y = expression("Total PM"[2.5]*" emission")) +
  theme(panel.background = element_rect(fill = 'beige', colour = 'red'))

print(g)

dev.off()
