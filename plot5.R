if (!require(sqldf))
  install.packages("sqldf")
library(sqldf)

## Load Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract total PM2.5 for each year for vehicle related sources

mvEmission <-sqldf('select year, sum(Emissions) as cumulativeEmission from NEI where type="ON-ROAD" group by year')

## Show PM 2.5 in Thousands
mvEmission$cumulativeEmission <- mvEmission$cumulativeEmission/1000

mvEmission<-transform(mvEmission,year=factor(year))

library(ggplot2)

## Plot data

png("plot5.png")

g <- ggplot(mvEmission, aes(x=year, y=cumulativeEmission)) +
  geom_bar(fill = "darkgreen", stat = "identity", width = .5) + 
  scale_fill_discrete(guide= 'none') +
  labs(y = expression("Total PM"[2.5]*" emission from motor vehicle sources (in Thousand)"), 
       x = "Year", 
       title = expression("Total PM"[2.5]*" emission from motor vehicle sources by year")) +
  theme(panel.background = element_rect(fill = 'beige', colour = 'red'))

print(g)

dev.off()
