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

#need to filter emissions for coal type first from SCC codes
Scc_level_3_Names <- count(SCC$SCC.Level.Three)
Scc_level_3_Coal <-Scc_level_3_Names[grep("Coal",Scc_level_3_Names)]
Scc_Codes_Coal <- SCC$SCC[SCC$SCC.Level.Three %in% Scc_level_3_Coal]
#select codes from NEI data
US_Coal_Emissions <- NEI[NEI$SCC %in% Scc_Codes_Coal,]
#group by year
annual_coal_emissions <- ddply(US_Coal_Emissions,.(year),summarise,total_emissions=sum(Emissions))

#plot
png(filename = "plot4.png", width = 480, height = 480, units = "px")
plot(annual_coal_emissions, type="h", xlab="Year", ylab="Total PM25 Emissions (tons)", main="Total annual Coal emissions")
dev.off()
