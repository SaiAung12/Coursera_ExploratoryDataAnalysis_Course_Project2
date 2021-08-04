## download and unzip dataset
if(!file.exists("./dataset")){dir.create("./dataset")}

downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(downloadUrl, destfile = "./dataset/download.zip")

unzip(zipfile = "./dataset/download.zip", exdir = "./dataset")

## read data
NEI <- readRDS("./dataset/summarySCC_PM25.rds")
SCC <- readRDS("./dataset/Source_Classification_Code.rds")

## find total emissions in Baltimore city according to years
baltimore_data <- aggregate(
        Emissions ~ year,
        data=subset(NEI, fips == "24510"),
        FUN =sum)
        
## plot histogram
png("plot2.png")

plot2 <- barplot(
        baltimore_data$Emissions,
        names.arg=baltimore_data$year,
        xlab="Year",
        ylab="PM2.5 Emissions in Kilotons",
        main="Total PM2.5 Emissions in Baltimore City over Years",
        ylim= c(0,(1.1 * max(baltimore_data$Emissions))),
        col=baltimore_data$year
)

text(x = plot2, y=round(baltimore_data$Emissions), labels = round(baltimore_data$Emissions), pos = 3)

dev.off()
