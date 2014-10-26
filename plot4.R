if (!require(sqldf))
  install.packages("sqldf")
library(sqldf)

## Load Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract total PM2.5 for each year for coal related sources

coalEmission <-sqldf('select year, sum(Emissions) as cumulativeEmission from NEI, SCC where SCC.SCC = NEI.SCC and EI_Sector like "%Coal%" group by year')

## Show PM 2.5 in Millions
coalEmission$cumulativeEmission <- coalEmission$cumulativeEmission/1000000

coalEmission<-transform(coalEmission,year=factor(year))

library(ggplot2)

## Plot data

png("plot4.png")

g <- ggplot(coalEmission, aes(x=year, y=cumulativeEmission)) +
  geom_bar(fill = "brown", stat = "identity", width = .5, xlim = c(0, 4)) + 
  scale_fill_discrete(guide= 'none') +
  labs(y = expression("Total PM"[2.5]*" emission from coal combustion-related sources (in Million)"), 
       x = "Year", 
       title = expression("Total PM"[2.5]*" emission from coal combustion-related sources by year")) +
  theme(panel.background = element_rect(fill = 'beige', colour = 'red'))

print(g)

dev.off()
