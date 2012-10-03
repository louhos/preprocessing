# This script converts the Shape files from fin_kuntajako_1milj_maa.zip
# into an R shape object and stores into an R Data file for 
# further distribution.

# Pick the original shape files from:
# http://beta.datavaalit.fi/storage/louhos/fin_kuntajako_1milj_maa.zip

library(sorvi)

f <- "fin_kuntajako_1milj_maa.shp"
sp <- readShapePoly(f)

# ------------------------------------------------------------------

# Field preprocessing

df <- as.data.frame(sp)

df$RegionLevel <- rep(NA, nrow(df)) 
df$RegionLevel[df$LocalisedC == "(3:Kunta,Kommun,Municipality)"] <- "Kunta"

df$language <- rep(NA, nrow(df)) 
df$language1[df$language == "(2:fin,swe)"] <- "Suomi"
df$language2[df$language == "(2:fin,swe)"] <- "Svenska"

municipality.names <- do.call(rbind, strsplit(sapply(sapply(strsplit(iconv(as.character(df$text), from = "latin1", to = "UTF-8"), ":"), function (x) {x[-1]}), function (x) {strsplit(x, ")")[[1]]}), ","))
df$Kunta_FI <- municipality.names[,1]
df$Kunta_SE <- municipality.names[,2]

# ------------------------------------------------------------------

# Attach preprocessed data to data frame
sp@data <- df

# Rename
kuntarajat.maa.shp <- sp

# ------------------------------------------------------------------

save(kuntarajat.maa.shp, file = "kuntarajat.maa.shp.rda")

# scp kuntarajat.maa.shp.rda antagomir@beta.datavaalit.fi:

