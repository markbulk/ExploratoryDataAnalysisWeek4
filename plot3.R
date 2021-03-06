library(data.table)
library(ggplot2)
setwd('/Volumes/MacStorage/Coursera Data/exdata-data-NEI_data')

required_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")
if(all(required_files %in% dir())) {
    ## This first line will likely take a few seconds. Be patient!
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
    
    # Plot 3: Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, 
    #         which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
    #         Which have seen increases in emissions from 1999–2008? 
    #         Use the ggplot2 plotting system to make a plot answer this question.
    dt.plot <- merge(NEI[fips == "24510"], SCC, by="SCC")[, list(Emissions=sum(Emissions)), by=list(year, type)]
    dt.plot[, Em1999 := sum(ifelse(year == 1999, Emissions, 0)), by=type]
    dt.plot[, bigger1999 := Emissions > Em1999]
    
    png("plot3.png", width = 480, height = 480)
    ggplot(data=dt.plot, mapping=aes(x=factor(year), y=Emissions/1e3, fill=bigger1999)) +
        geom_bar(stat="identity") + geom_hline(yintercept = 0) +
        facet_wrap(~ type, nrow = 1) +
        scale_x_discrete(name = "Year") +
        scale_y_continuous(name = "Baltimore City PM2.5 Emissions\n(Thousands of Tons)") +
        scale_fill_discrete(name = "Is Year Bigger than 1999?") +
        theme(legend.position = c(0.8, 0.8))
    dev.off()
} else {
    print("Required files not found in directory!")
}