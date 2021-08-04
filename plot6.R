## download and unzip dataset
if(!file.exists("./dataset")){dir.create("./dataset")}

downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(downloadUrl, destfile = "./dataset/download.zip")

unzip(zipfile = "./dataset/download.zip", exdir = "./dataset")

## read data
NEI <- readRDS("./dataset/summarySCC_PM25.rds")
SCC <- readRDS("./dataset/Source_Classification_Code.rds")

## find Motor Vehicle related emissions comparison of Baltimore and LA cities according to years
motor_data_index <- data.frame()

# select all observations that inlude "motor" or "vehicle" phrase
for (column in names(SCC)){
        output <- data.frame(SCC[grepl("motor|vehicle", SCC[,column], ignore.case=TRUE), 1])
        motor_data_index <- rbind(motor_data_index, output)
} 

# take out unique SSCs
motor_data_index <- data.frame(unique(motor_data_index[,1]))

# find total emissions in Baltimore city according
motor_emission_baltimore <- aggregate(Emissions ~ year,
                                 data = subset(NEI[NEI$SCC %in% motor_data_index[,1],], fips == "24510"), 
                                 FUN = sum)
motor_emission_baltimore$area = c("Baltimore", "Baltimore", "Baltimore", "Baltimore")

# find total emissions in LA city according
motor_emission_LA <- aggregate(Emissions ~ year,
                                      data = subset(NEI[NEI$SCC %in% motor_data_index[,1],], fips == "06037"), 
                                      FUN = sum)
motor_emission_LA$area = c("Los_Angeles", "Los_Angeles", "Los_Angeles", "Los_Angeles")

# combining datasets for the plot
motor_emission_comparison <- rbind(motor_emission_baltimore, motor_emission_LA)

##plot histogram
png("plot6.png")

ggplot(motor_emission_comparison, aes(x=factor(year),y=Emissions,fill=area)) +
        geom_bar(stat = "identity", position = 'dodge') +
        geom_text(aes(label = round(Emissions)), position = position_dodge(0.9), vjust = -0.4, size =3) +
        labs(x = "Year", y = "PM2.5 Emissions in Kilotons", title = "Motor Vehicle related PM2.5 Emissions in Baltimore and LA over Years")

dev.off()