library(data.table)
library(ggplot2)
setwd('/Volumes/MacStorage/Coursera Data/exdata-data-NEI_data')

required_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")
if(all(required_files %in% dir())) {
    ## This first line will likely take a few seconds. Be patient!
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
    
    # Plot 4: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
    dt.plot <- merge(NEI, SCC[grepl("^Fuel Comb -", EI.Sector) & grepl("- Coal$", EI.Sector)], by = "SCC")
    
    png("plot4.png", width = 480, height = 480)
    ggplot(data=dt.plot[, list(Emissions = sum(Emissions)), by=year],
           mapping=aes(x=factor(year), y=Emissions/1e3)) +
        geom_bar(stat="identity", fill="steelblue") + geom_hline(yintercept = 0) +
        scale_x_discrete(name = "Year") + 
        scale_y_continuous(name = "U.S. Coal Combustion-Related PM2.5\n(Thousands of Tons)") +
        geom_text(mapping=aes(y=Emissions/1e3+30, label=paste0(round(Emissions/1e3,1))))
    dev.off()
} else {
    print("Required files not found in directory!")
}