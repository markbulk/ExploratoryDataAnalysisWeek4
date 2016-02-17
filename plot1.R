library(data.table)
setwd('/Volumes/MacStorage/Coursera Data/exdata-data-NEI_data')
required_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")
if(all(required_files %in% dir())) {
    ## This first line will likely take a few seconds. Be patient!
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
    
    # Plot 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
    # Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
    dt.plot <- NEI[, list(Emissions = sum(Emissions)), by=year]
    png("plot1.png", width = 480, height = 480)
    barplot(dt.plot$Emissions/1e6, names.arg=dt.plot$year, 
            ylab="U.S. Total Emissions (Millions of Tons of PM2.5)", xlab = "Year")
    abline(h=0)
    dev.off()
} else {
    print("Required files not found in directory!")
}