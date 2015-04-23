#collecting data
if (!file.exists("summarySCC_PM25.rds")){
    if (!file.exists("NEI_data.zip")){
        setInternet2(use = TRUE)
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                      "NEI_data.zip",
                      mode="wb")
    }
    # unzip the contents of the zip to working folder
    unzip("NEI_data.zip", exdir=".")
}

#loading data if not already loaded
if(sum(ls()=="NEI") == 0){
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
}

#plot
library(plyr)
annual_pollutants <- ddply(NEI,.(year),summarise,total_emissions=sum(Emissions))
png(filename = "plot1.png", width = 480, height = 480, units = "px")
plot(annual_pollutants, type="h", xlab="Year", ylab="Total PM25 Emissions (tons)", main="Total annual emissions")
dev.off()
