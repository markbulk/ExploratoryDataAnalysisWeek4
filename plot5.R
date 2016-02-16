library(data.table)
library(ggplot2)
setwd('/Volumes/MacStorage/Coursera Data/exdata-data-NEI_data')

## This first line will likely take a few seconds. Be patient!
NEI <- data.table(readRDS("summarySCC_PM25.rds"))
SCC <- data.table(readRDS("Source_Classification_Code.rds"))

# Plot 5: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
#         From before: Baltimore City, Maryland (fips == "24510")
dt.plot <- merge(NEI[fips == "24510"], SCC[SCC.Level.One == "Mobile Sources" & grepl("ighway Vehicle", SCC.Level.Two)], by = "SCC")
dt.plot <- dt.plot[, list(Emissions = sum(Emissions)), by=year]
dt.plot[, baseline := sum(ifelse(year == 1999, Emissions, 0))]
dt.plot[, percent_change := (Emissions - baseline)/baseline]

png("plot5.png", width = 480, height = 480)
ggplot(data=dt.plot,
       mapping=aes(x=factor(year), y=Emissions)) +
    geom_bar(stat="identity", fill="steelblue") + geom_hline(yintercept = 0) +
    scale_x_discrete(name = "Year") + 
    scale_y_continuous(name = "Baltimore City Motor Vehicle-Related PM2.5\n(Tons)") +
    geom_text(mapping=aes(y=baseline, label=paste0(round(Emissions,0), "\n", round(percent_change*100,0), "%"))) +
    annotate("text", x=1, y= max(dt.plot$baseline)+20, label = paste0("Tons, Percent Change from 1999"), fontface = "bold")
dev.off()