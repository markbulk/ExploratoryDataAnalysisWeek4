library(data.table)
setwd('/Volumes/MacStorage/Coursera Data/exdata-data-NEI_data')

## This first line will likely take a few seconds. Be patient!
NEI <- data.table(readRDS("summarySCC_PM25.rds"))
SCC <- data.table(readRDS("Source_Classification_Code.rds"))

# Plot 2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
dt.plot <- NEI[fips == "24510", list(Emissions = sum(Emissions)), by=year]
png("plot2.png", width = 480, height = 480)
barplot(dt.plot$Emissions/1e3, names.arg=dt.plot$year, 
        ylab="Total Baltimore City Emissions (Thousands of Tons of PM2.5)", xlab = "Year")
abline(h=0)
dev.off()