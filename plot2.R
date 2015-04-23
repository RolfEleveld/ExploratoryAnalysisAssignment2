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

#plot total annual emissions
library(plyr)
Baltimore_city_Maryland_Emissions <- NEI[NEI$fips=="24510",]
baltimore_annual_pollutants <- ddply(Baltimore_city_Maryland_Emissions,.(year),summarise,total_emissions=sum(Emissions))
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(baltimore_annual_pollutants, type="h", xlab="Year", ylab="Total PM25 Emissions (tons)", main="Total annual emissions in Baltimore")
dev.off()
