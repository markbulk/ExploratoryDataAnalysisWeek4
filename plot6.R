library(data.table)
library(ggplot2)
setwd('/Volumes/MacStorage/Coursera Data/exdata-data-NEI_data')

required_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")
if(all(required_files %in% dir())) {
    ## This first line will likely take a few seconds. Be patient!
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
    
    # Plot 6:  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in
    #          Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
    dt.fips <- data.table(fips = c("24510", "06037"), city = c("Baltimore City", "Los Angeles County"))
    dt.plot <- merge(merge(dt.fips, NEI, by="fips"), SCC[SCC.Level.One == "Mobile Sources" & grepl("ighway Vehicle", SCC.Level.Two)], by = "SCC")
    dt.plot <- dt.plot[, list(Emissions = sum(Emissions)), by=list(year, city)]
    dt.plot[, baseline := sum(ifelse(year == 1999, Emissions, 0)), by=city]
    dt.plot[, change := Emissions - baseline]
    dt.plot[, percent_change := change / baseline]

    png("plot6.png", width = 480, height = 480)
    ggplot(data=dt.plot,
           mapping=aes(x=factor(year), y=Emissions/1e3)) +
        geom_bar(stat="identity", fill="steelblue") + geom_hline(yintercept = 0) +
        scale_x_discrete(name = "Year") + 
        scale_y_continuous(name = "Vehicle-Related PM2.5\n(Thousands of Tons)") +
        facet_wrap(~ city) +
        geom_text(mapping=aes(y=baseline/1e3, label = paste0(round(percent_change*100, 1), '%\n(', round(change, 1), ')'))) +
        geom_text(x = 1, label = "Percent & (Total) Change from 1999", mapping=aes(y = baseline/1e3 + 0.6), hjust = 0 )
    dev.off()
} else {
    print("Required files not found in directory!")
}