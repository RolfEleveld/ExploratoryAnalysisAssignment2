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
Scc_level_3_Vehicles <-Scc_level_3_Names[grep("Vehicle",Scc_level_3_Names)]
Scc_Codes_Vehicles <- SCC$SCC[SCC$SCC.Level.Three %in% Scc_level_3_Vehicles]

#Get Baltimore Vehicle Data
Baltimore_city_Maryland_Emissions <- NEI[NEI$fips=="24510",]
Baltimore_Vehicle_Emissions <- Baltimore_city_Maryland_Emissions[Baltimore_city_Maryland_Emissions$SCC %in% Scc_Codes_Vehicles,]

#group by year
annual_vehicle_emissions_baltimore <- ddply(Baltimore_Vehicle_Emissions,.(year),summarise,total_emissions=sum(Emissions))

#plot
png(filename = "plot5.png", width = 480, height = 480, units = "px")
plot(annual_vehicle_emissions_baltimore, 
    type="h", 
    xlab="Year", 
    ylab="Total PM25 Emissions (tons)", 
    main="Total annual vehicle emissions in Baltimore")
dev.off()
