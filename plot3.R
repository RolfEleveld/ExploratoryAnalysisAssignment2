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

#need to combine emissions per type per year first
Baltimore_city_Maryland_Emissions <- NEI[NEI$fips=="24510",]
library(plyr)
library(ggplot2)
baltimore_annual_pollutants_by_type <- ddply(Baltimore_city_Maryland_Emissions,.(year,type),summarise,total_emissions=sum(Emissions))

#plot
png(filename = "plot3.png", width = 480, height = 480, units = "px")
qplot(year, total_emissions, data=baltimore_annual_pollutants_by_type, facets=.~type, geom="path", ylab="Total Emissions (tons)", xlab="Year", main="Total Annual Emissions in Baltimore by Type")
dev.off()
